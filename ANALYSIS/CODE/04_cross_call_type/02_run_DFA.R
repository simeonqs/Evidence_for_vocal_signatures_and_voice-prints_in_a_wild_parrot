# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 06-02-2022
# Date last modified: 12-03-2022
# Author: Simeon Q. Smeele
# Description: Running DFA.  
# This version also takes recording into account. 
# This version moves code to functions and iterates. 
# This version has additional testing code. 
# This version uses the combined dataset and removes the code for 2020. 
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

# Test if st and wave match
if(!all(st$fs == names(mfcc_out))) stop('Problem waves and st.')

# Add column with broad call type
source(path_call_type_classification)
st$main_type = sapply(st$`call type`, function(type){
  y = names(types_include)[sapply(types_include, function(x) type %in% x)]
  return(ifelse(length(y) == 0, NA, y))
})

# Run full permuted dfa
N_train = 15
N_test = 10
pdf(path_pdf_pdfa, 7, 7)
par(mfrow = c(3, 3))
# Combined
pdfa_out_1 = run.pdfa(train_set = 'contact', 
                    test_set = c('growl', 'alarm', 'growl_low', 'trruup'),
                    N_train = 30, N_test = N_test,
                    main = 'combined, contact to growly',
                    mfcc_out = mfcc_out, st = st)
length(which(pdfa_out_1$score_diff < 0))/length(pdfa_out_1$score_diff)
pdfa_out_2 = run.pdfa(train_set = c('growl', 'alarm', 'growl_low', 'trruup'), 
         test_set = 'contact',
         main = 'combined, growly to contact',
         mfcc_out = mfcc_out, st = st)
length(which(pdfa_out_2$score_diff < 0))/length(pdfa_out_2$score_diff)
table(pdfa_out_2$most_important)
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
         N_train = 5, N_test = 5,
         test_set = c('growl'), 
         main = 'combined, growl to growl',
         mfcc_out = mfcc_out, st = st)
dev.off()




