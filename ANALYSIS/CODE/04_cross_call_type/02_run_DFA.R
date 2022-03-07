# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 06-02-2022
# Date last modified: 02-03-2022
# Author: Simeon Q. Smeele
# Description: Running DFA.  
# This version also takes recording into account. 
# This version moves code to functions and iterates. 
# This version has additional testing code. 
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

# Test if st and wave match
if(!all(st$fs == names(mfcc_out))) stop('Problem waves and st.')

# Add column with broad call type
source(path_call_type_classification)
st$main_type = sapply(st$`call type`, function(type){
  y = names(types_include)[sapply(types_include, function(x) type %in% x)]
  return(ifelse(length(y) == 0, NA, y))
})
st_20$main_type = sapply(st_20$`call type`, function(type){
  y = names(types_include)[sapply(types_include, function(x) type %in% x)]
  return(ifelse(length(y) == 0, NA, y))
})

# Run full permuted dfa
N_train = 15
N_test = 10
pdf(path_pdf_pdfa, 7, 7)
par(mfrow = c(3, 3))
# Combined
run.pdfa(train_set = 'contact', 
         test_set = c('growl', 'alarm', 'growl_low', 'trruup'),
         N_train = N_train, N_test = N_test,
         main = 'combined, contact to growly',
         mfcc_out = mfcc_out, st = st)
run.pdfa(train_set = c('growl', 'alarm', 'growl_low', 'trruup'), 
         test_set = 'contact',
         main = 'combined, growly to contact',
         mfcc_out = mfcc_out, st = st)
run.pdfa(train_set = 'contact', 
         N_train = N_train, N_test = N_test,
         test_set = 'contact', 
         main = 'combined, contact to contact',
         mfcc_out = mfcc_out, st = st)
run.pdfa(train_set = c('growl', 'alarm', 'growl_low', 'trruup'), 
         N_train = N_train, N_test = N_test,
         test_set = c('growl', 'alarm', 'growl_low', 'trruup'), 
         main = 'combined, growly to growly',
         mfcc_out = mfcc_out, st = st)
run.pdfa(train_set = c('tja', 'tjup', 'kaw'), 
         N_train = 10, N_test = 5,
         test_set = c('tja', 'tjup', 'kaw'), 
         main = 'combined, other tonal to other tonal',
         mfcc_out = mfcc_out, st = st)
run.pdfa(train_set = c('growl'), 
         N_train = 10, N_test = 5,
         test_set = c('growl'), 
         main = 'combined, growl to growl',
         mfcc_out = mfcc_out, st = st)
# 2020
par(mfrow = c(2,2))
run.pdfa(train_set = 'contact', 
         N_train = N_train, N_test = N_test,
         test_set = c('growl', 'alarm', 'growl_low', 'trruup'),
         N_train = N_train, N_test = N_test,
         main = '2020, contact to growly',
         mfcc_out = mfcc_out_20, st = st_20)
run.pdfa(train_set = c('growl', 'alarm', 'growl_low', 'trruup'), 
         N_train = N_train, N_test = N_test,
         test_set = 'contact',
         main = '2020, growly to contact',
         mfcc_out = mfcc_out_20, st = st_20)
run.pdfa(train_set = 'contact', 
         N_train = N_train, N_test = N_test,
         test_set = 'contact', 
         main = '2020, contact to contact',
         mfcc_out = mfcc_out_20, st = st_20)
run.pdfa(train_set = c('growl', 'alarm', 'growl_low', 'trruup'), 
         N_train = N_train, N_test = N_test,
         test_set = c('growl', 'alarm', 'growl_low', 'trruup'), 
         main = '2020, growly to growly',
         mfcc_out = mfcc_out_20, st = st_20)
dev.off()




