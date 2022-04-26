# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 06-02-2022
# Date last modified: 25-04-2022
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
load(path_specan_out)

# Test if st and wave match
if(!all(st$fs == names(mfcc_out))) stop('Problem waves and st.')

# Add column with broad call type
source(path_call_type_classification)
st$main_type = sapply(st$`call type`, function(type){
  y = names(types_include)[sapply(types_include, function(x) type %in% x)]
  return(ifelse(length(y) == 0, NA, y))
})

# Run full permuted dfa
pdf(path_pdf_pdfa, 7, 5)
par(mfrow = c(2, 3))
# Combined
pdfa_out_1 = run.pdfa(train_set = 'contact', 
                      test_set = c('growl', 'alarm', 'growl_low', 'trruup'),
                      N_train = 30, N_test = 10,
                      main = 'contact to growly',
                      mfcc_out = mfcc_out, st = st)
pdfa_out_2 = run.pdfa(train_set = c('growl', 'alarm', 'growl_low', 'trruup'), 
                      test_set = 'contact',
                      main = 'growly to contact',
                      mfcc_out = mfcc_out, st = st)
pdfa_out_3 = run.pdfa(train_set = 'contact', 
                      N_train = 10, N_test = 15,
                      test_set = 'contact', 
                      main = 'contact to contact',
                      mfcc_out = mfcc_out, st = st)
pdfa_out_4 = run.pdfa(train_set = c('growl', 'alarm', 'growl_low', 'trruup'), 
                      N_train = 5, N_test = 5,
                      test_set = c('growl', 'alarm', 'growl_low', 'trruup'), 
                      main = 'growly to growly',
                      mfcc_out = mfcc_out, st = st)
pdfa_out_5 = run.pdfa(train_set = c('tja', 'tjup', 'kaw'), 
                      N_train = 5, N_test = 2,
                      test_set = c('tja', 'tjup', 'kaw'), 
                      main = 'other tonal to other tonal',
                      mfcc_out = mfcc_out, st = st)
pdfa_out_6 = run.pdfa(train_set = c('alarm'), 
                      N_train = 5, N_test = 2,
                      test_set = c('alarm'), 
                      main = 'alarm to alarm',
                      mfcc_out = mfcc_out, st = st)
dev.off()

# Save results in txt
sink(path_dfa_output)
cat(sprintf('Score contact to growly: %s', round(mean(pdfa_out_1$score_diff), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('Overlap 0 contact to growly: %s', 
            round(mean(length(which(pdfa_out_1$score_diff < 0))/length(pdfa_out_1$score_diff)), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('N contact to growly: %s', round(mean(pdfa_out_1$N), 2)), sep="\n",append=TRUE)
cat(sprintf('Loadings contact to growly: %s', paste(pdfa_out_1$most_important, collapse = ', ')), 
    sep="\n",append=TRUE)
cat(sprintf('Score growly to contact: %s', round(mean(pdfa_out_2$score_diff), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('Overlap 0 growly to contact: %s', 
            round(mean(length(which(pdfa_out_2$score_diff < 0))/length(pdfa_out_2$score_diff)), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('N growly to contact: %s', round(mean(pdfa_out_2$N), 2)), sep="\n",append=TRUE)
cat(sprintf('Loadings growly to contact: %s', paste(pdfa_out_2$most_important, collapse = ', ')), 
    sep="\n",append=TRUE)
cat(sprintf('Score contact to contact: %s', round(mean(pdfa_out_3$score_diff), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('Overlap 0 contact to contact: %s', 
            round(mean(length(which(pdfa_out_3$score_diff < 0))/length(pdfa_out_3$score_diff)), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('N contact to contact: %s', round(mean(pdfa_out_3$N), 2)), sep="\n",append=TRUE)
cat(sprintf('Loadings contact to contact: %s', paste(pdfa_out_3$most_important, collapse = ', ')), 
    sep="\n",append=TRUE)
cat(sprintf('Score growly to growly: %s', round(mean(pdfa_out_4$score_diff), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('Overlap 0 growly to growly: %s', 
            round(mean(length(which(pdfa_out_4$score_diff < 0))/length(pdfa_out_4$score_diff)), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('N growly to growly: %s', round(mean(pdfa_out_4$N), 2)), sep="\n",append=TRUE)
cat(sprintf('Loadings growly to growly: %s', paste(pdfa_out_4$most_important, collapse = ', ')), 
    sep="\n",append=TRUE)
cat(sprintf('Score other tonal to other tonal: %s', round(mean(pdfa_out_5$score_diff), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('Overlap 0 other tonal to other tonal: %s', 
            round(mean(length(which(pdfa_out_5$score_diff < 0))/length(pdfa_out_5$score_diff)), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('N other tonal to other tonal: %s', round(mean(pdfa_out_5$N), 2)), sep="\n",append=TRUE)
cat(sprintf('Loadings other tonal to other tonal: %s', paste(pdfa_out_5$most_important, 
                                                             collapse = ', ')), 
    sep="\n",append=TRUE)
cat(sprintf('Score alarm to alarm: %s', round(mean(pdfa_out_6$score_diff), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('Overlap 0 alarm to alarm: %s', 
            round(mean(length(which(pdfa_out_6$score_diff < 0))/length(pdfa_out_6$score_diff)), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('N alarm to alarm: %s', round(mean(pdfa_out_6$N), 2)), sep="\n",append=TRUE)
cat(sprintf('Loadings alarm to alarm: %s', paste(pdfa_out_6$most_important, collapse = ', ')), 
    sep="\n",append=TRUE)
sink()

# Run with all data
pdfa_out_all = run.pdfa(train_set = c('contact', 'tja', 'tjup', 'frill', 'other_tonal', 'short_contact',
                                      'kaw'), 
                        test_set = c('growl', 'alarm', 'growl_low', 'trruup'),
                        N_train = 30, N_test = 10,
                        main = 'contact to growly',
                        mfcc_out = mfcc_out, st = st)

pdfa_out_all_rev = run.pdfa(train_set = c('growl', 'alarm', 'growl_low', 'trruup'), 
                            test_set = c('contact', 'tja', 'tjup', 'frill', 'other_tonal', 'short_contact',
                                         'kaw'),
                            N_train = 5, N_test = 10,
                            main = 'contact to growly',
                            mfcc_out = mfcc_out, st = st)

pdfa_out_all_all = run.pdfa(train_set = c('contact', 'tja', 'tjup', 'frill', 'other_tonal', 'short_contact',
                                          'kaw', 'growl', 'alarm', 'growl_low', 'trruup'), 
                            test_set = c('contact', 'tja', 'tjup', 'frill', 'other_tonal', 'short_contact',
                                         'kaw', 'growl', 'alarm', 'growl_low', 'trruup'),
                            N_train = 20, N_test = 10,
                            main = '',
                            mfcc_out = mfcc_out, st = st)

pdfa_out_specan = run.pdfa(train_set = c('contact', 'tja', 'tjup', 'frill', 'other_tonal', 'short_contact',
                                         'kaw'), 
                           test_set = c('growl', 'alarm', 'growl_low', 'trruup'),
                           N_train = 30, N_test = 10,
                           main = 'contact to growly',
                           mfcc_out = specan_out, st = st)
