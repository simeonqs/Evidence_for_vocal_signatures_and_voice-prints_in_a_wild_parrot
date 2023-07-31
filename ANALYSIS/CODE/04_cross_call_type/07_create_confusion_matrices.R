# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 06-02-2022
# Date last modified: 29-07-2023
# Author: Simeon Q. Smeele
# Description: Running DFA once to create confusion matrices.
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('tidyverse', 'MASS', 'caret')
for(i in libraries){
  if(! i %in% installed.packages()) lapply(i, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Clean R
rm(list=ls()) 

# Paths
source('ANALYSIS/CODE/paths.R')

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Load data
load(path_data)
load(path_mfcc_out)
load(path_specan_out)

# Test if st and wave match
if(!all(st$fs == names(mfcc_out))) stop('Problem waves and st.')

# Add column with broad call type
source(path_call_type_classification)
st$main_type = sapply(st$`call type`, function(type){
  y = names(types_include)[sapply(types_include, function(x) type %in% x)]
  return(ifelse(length(y) == 0, NA, y))
})


# Tonal to growly
out = subset.dfa(train_set = c('contact', 'tja', 'tjup', 'frill', 'other_tonal', 'short_contact', 'kaw'), 
                 test_set = c('growl', 'alarm', 'growl_low', 'trruup'),
                 N_train = 40, 
                 N_test = 5,
                 st = st,
                 balance = T)

dfa_out = run.dfa(names_train = out$names_train, 
                  names_test = out$names_test, 
                  mfcc_out = mfcc_out,
                  permute = FALSE,
                  print_predictions = TRUE)
conf_mat = confusionMatrix(dfa_out$predicted_labels, 
                           factor(dfa_out$true_labels, levels = levels(dfa_out$predicted_labels)))

table = data.frame(conf_mat$table)

plotTable = table %>%
  mutate(goodbad = ifelse(table$Prediction == table$Reference, "good", "bad")) %>%
  group_by(Reference) %>%
  mutate(prop = Freq/sum(Freq))

pdf('ANALYSIS/RESULTS/figures/confusion matrix tonal to growly.pdf')
ggplot(data = plotTable, mapping = aes(x = Reference, y = Prediction, fill = goodbad, alpha = prop)) +
  geom_tile() +
  geom_text(aes(label = Freq), vjust = .5, fontface  = "bold", alpha = 1) +
  scale_fill_manual(values = c(good = "green", bad = "red")) +
  theme_bw() +
  xlim(rev(levels(table$Reference))) |> print()
dev.off()

# Growly to tonal
out = subset.dfa(train_set = c('growl', 'alarm', 'growl_low', 'trruup'), 
                 test_set = c('contact', 'tja', 'tjup', 'frill', 'other_tonal', 
                              'short_contact', 'kaw'),
                 N_train = 20, 
                 N_test = 5,
                 st = st,
                 balance = T)

dfa_out = run.dfa(names_train = out$names_train, 
                  names_test = out$names_test, 
                  mfcc_out = mfcc_out,
                  permute = FALSE,
                  print_predictions = TRUE)
conf_mat = confusionMatrix(dfa_out$predicted_labels, 
                           factor(dfa_out$true_labels, levels = levels(dfa_out$predicted_labels)))

table = data.frame(conf_mat$table)

plotTable = table %>%
  mutate(goodbad = ifelse(table$Prediction == table$Reference, "good", "bad")) %>%
  group_by(Reference) %>%
  mutate(prop = Freq/sum(Freq))

pdf('ANALYSIS/RESULTS/figures/confusion matrix growly to tonal.pdf')
ggplot(data = plotTable, mapping = aes(x = Reference, y = Prediction, fill = goodbad, alpha = prop)) +
  geom_tile() +
  geom_text(aes(label = Freq), vjust = .5, fontface  = "bold", alpha = 1) +
  scale_fill_manual(values = c(good = "green", bad = "red")) +
  theme_bw() +
  xlim(rev(levels(table$Reference))) |> print()
dev.off()
