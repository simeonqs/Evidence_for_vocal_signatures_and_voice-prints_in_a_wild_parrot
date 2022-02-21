# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 06-02-2022
# Date last modified: 18-02-2022
# Author: Simeon Q. Smeele
# Description: Running DFA.  
# This version also takes recording into account. 
# This version moves code to functions and iterates. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('tidyverse', 'warbleR', 'MASS')
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

# Merge datasets
st_20$`complete sequence` = NA
st_20$notes = NA
st_21$notes.x = NA
st_21$notes.y = NA
st_21$...8 = NA
st = rbind(st_20, st_21)

# Add column with broad call type
source(path_call_type_classification)
st$main_type = sapply(st$`call type`, function(type){
  y = names(types_include)[sapply(types_include, function(x) type %in% x)]
  return(ifelse(length(y) == 0, NA, y))
})

# Run full permuted dfa
train_set = 'contact'
test_set = c('growl', 'alarm', 'growl_low', 'trruup')
pdfa_out = lapply(1:100, function(i){
  
  out = subset.dfa(N_train = 15, N_test = 10, train_set = train_set, test_set = test_set)

  names_train = st$fs[which(st$bird %in% out$inds_include & st$main_type %in% train_set & 
                              st$file %in% out$recs_train)]
  names_test = st$fs[which(st$bird %in% out$inds_include & st$main_type %in% test_set & 
                             st$file %in% out$recs_test)]
  dfa_out = run.dfa(names_train, names_test)
  
  return(dfa_out)
  
}) %>% bind_rows

plot(density(pdfa_out$score_random), lwd = 3, col = 4, main = '', 
     xlab = 'proportion correct classified', ylab = 'density', xlim = c(0, 0.5))
lines(density(pdfa_out$score), lwd = 3, col = 3)


# # Now subset training to only include 10 calls per individual
# names_train_slim = c()
# for(ind in out$inds_include){
#   sub_names = names_train[st[names_train,]$bird == ind]
#   names_train_slim = c(names_train_slim, sample(sub_names, 10))
# }
# run.dfa(names_train_slim, names_test)
