# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 07-08-2023
# Date last modified: 07-08-2023
# Author: Simeon Q. Smeele
# Description: Analysing the scorings of the second observer. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('callsync', 'tidyverse', 'caret')
for(lib in libraries){
  if(! lib %in% installed.packages()) lapply(lib, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Clean R
rm(list=ls()) 
set.seed(1)

# Paths
source('ANALYSIS/CODE/paths.R')

# Load data
load(path_data)
load(path_waves)
indexes = read.csv2(sprintf('%s/random_calls.csv', path_observer_reliability),
                    row.names = 1)

# List scored spectrograms
files = list.files(path_observer_reliability, full.names = TRUE, recursive = TRUE, pattern = '([0-9]).pdf')
if(length(files) != 200) warning('Not exactly 200 scorings found.')
if(length(files) != length(unique(basename(files)))) warning('Some scorings are not unique.')

# Get call types
predicted_labels = vapply(1:200, function(i) 
  files[str_detect(files, sprintf('/%s.pdf', i))] |> strsplit('/') |> sapply(`[`, 5), 
  character(1))

# Get true labels
rownames(st) = st$fs
true_labels = vapply(indexes$x, function(fs){
  is_in = vapply(data_sets[-12], function(ds) fs %in% ds, logical(1))
  if(any(is_in)) ct = names(data_sets[-12])[is_in] else ct = 'none'
  return(ct)
}, character(1))

# Remove cases that did not fall into any of the 11 categories
predicted_labels = predicted_labels[true_labels != 'none']
true_labels = true_labels[true_labels != 'none']

# Make confusion matrix
conf_mat = confusionMatrix(factor(predicted_labels, levels = names(data_sets[-12])),
                           factor(true_labels, levels = names(data_sets[-12])))
print(conf_mat)

table = data.frame(conf_mat$table)

plotTable = table %>%
  mutate(goodbad = ifelse(table$Prediction == table$Reference, "good", "bad")) %>%
  group_by(Reference) %>%
  mutate(prop = Freq/sum(Freq))

pdf('ANALYSIS/RESULTS/figures/confusion matrix observer reliability.pdf', 10, 5)
ggplot(data = plotTable, mapping = aes(x = Reference, y = Prediction, fill = goodbad, alpha = prop)) +
  geom_tile() +
  xlab('First observer') +
  ylab('Second observer') +
  geom_text(aes(label = Freq), vjust = .5, fontface  = "bold", alpha = 1) +
  scale_fill_manual(values = c(good = "green", bad = "red")) +
  theme_bw() +
  xlim(rev(levels(table$Reference))) |> print()
dev.off()

# Make it for tonal vs growly
true_binary = ifelse(true_labels %in% c('growl', 'alarm', 'growl_low', 'trruup'), 
                     'growly', 'tonal')
pred_binary = ifelse(predicted_labels %in% c('growl', 'alarm', 'growl_low', 'trruup'), 
                     'growly', 'tonal')

conf_mat = confusionMatrix(factor(true_binary, levels = c('growly', 'tonal')),
                           factor(pred_binary, levels = c('growly', 'tonal')))
print(conf_mat)

table = data.frame(conf_mat$table)

plotTable = table %>%
  mutate(goodbad = ifelse(table$Prediction == table$Reference, "good", "bad")) %>%
  group_by(Reference) %>%
  mutate(prop = Freq/sum(Freq))

pdf('ANALYSIS/RESULTS/figures/confusion matrix observer reliability - binary.pdf')
ggplot(data = plotTable, mapping = aes(x = Reference, y = Prediction, fill = goodbad, alpha = prop)) +
  geom_tile() +
  xlab('First observer') +
  ylab('Second observer') +
  geom_text(aes(label = Freq), vjust = .5, fontface  = "bold", alpha = 1) +
  scale_fill_manual(values = c(good = "green", bad = "red")) +
  theme_bw() +
  xlim(rev(levels(table$Reference))) |> print()
dev.off()





