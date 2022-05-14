# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 10-05-2022
# Date last modified: 14-05-2022
# Author: Simeon Q. Smeele
# Description: Running random forest. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('tidyverse', 'randomForest', 'caret')
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

# Run full prfs
## pdf
pdf(path_pdf_prf, 7, 5)
par(mfrow = c(2, 3))
## txt
sink(path_rf_output)
## contact to contact
prf_out = run.prf(train_set = 'contact', 
                  N_train = 40, N_test = 5,
                  test_set = 'contact', 
                  main = 'contact to contact',
                  mfcc_out = mfcc_out, st = st)
cat("-------------------------------------------------------------------------", sep="\n",append=TRUE)
cat("Contact to contact", sep="\n",append=TRUE)
cat("Contact to contact", sep="\n",append=TRUE)
cat(sprintf('Score trained: %s', round(mean(prf_out$score), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('Score random: %s', round(mean(prf_out$score_random), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('Diff: %s', round(mean(prf_out$score_diff), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('Overlap 0: %s', 
            round(mean(length(which(prf_out$score_diff < 0))/length(prf_out$score_diff)), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('N: %s', round(mean(prf_out$N), 2)), sep="\n",append=TRUE)
## tonal to growly
prf_out = run.prf(train_set = c('contact', 'tja', 'tjup', 'frill', 'other_tonal', 'short_contact',
                                'kaw'), 
                  test_set = c('growl', 'alarm', 'growl_low', 'trruup'),
                  N_train = 40, N_test = 5,
                  main = 'tonal to growly',
                  mfcc_out = mfcc_out, st = st)
cat("-------------------------------------------------------------------------", sep="\n",append=TRUE)
cat("Tonal to growly", sep="\n",append=TRUE)
cat("Contact to contact", sep="\n",append=TRUE)
cat(sprintf('Score trained: %s', round(mean(prf_out$score), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('Score random: %s', round(mean(prf_out$score_random), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('Diff: %s', round(mean(prf_out$score_diff), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('Overlap 0: %s', 
            round(mean(length(which(prf_out$score_diff < 0))/length(prf_out$score_diff)), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('N: %s', round(mean(prf_out$N), 2)), sep="\n",append=TRUE)
cat(sprintf('Loadings: %s', paste(prf_out$most_important, collapse = ', ')), 
    sep="\n",append=TRUE)
## growly to tonal
prf_out = run.prf(train_set = c('growl', 'alarm', 'growl_low', 'trruup'), 
                  test_set = c('contact', 'tja', 'tjup', 'frill', 'other_tonal', 'short_contact',
                               'kaw'),
                  N_train = 20, N_test = 5,
                  main = 'growly to tonal',
                  mfcc_out = mfcc_out, st = st)
cat("-------------------------------------------------------------------------", sep="\n",append=TRUE)
cat("Growly to tonal", sep="\n",append=TRUE)
cat("Contact to contact", sep="\n",append=TRUE)
cat(sprintf('Score trained: %s', round(mean(prf_out$score), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('Score random: %s', round(mean(prf_out$score_random), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('Diff: %s', round(mean(prf_out$score_diff), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('Overlap 0: %s', 
            round(mean(length(which(prf_out$score_diff < 0))/length(prf_out$score_diff)), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('N: %s', round(mean(prf_out$N), 2)), sep="\n",append=TRUE)
cat(sprintf('Loadings: %s', paste(prf_out$most_important, collapse = ', ')), 
    sep="\n",append=TRUE)
## all to all
prf_out = run.prf(train_set = c('contact', 'tja', 'tjup', 'frill', 'other_tonal', 'short_contact',
                                'kaw', 'growl', 'alarm', 'growl_low', 'trruup'), 
                  test_set = c('contact', 'tja', 'tjup', 'frill', 'other_tonal', 'short_contact',
                               'kaw', 'growl', 'alarm', 'growl_low', 'trruup'),
                  N_train = 20, N_test = 5,
                  main = 'all to all',
                  mfcc_out = mfcc_out, st = st)
cat("-------------------------------------------------------------------------", sep="\n",append=TRUE)
cat("All to all", sep="\n",append=TRUE)
cat("Contact to contact", sep="\n",append=TRUE)
cat(sprintf('Score trained: %s', round(mean(prf_out$score), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('Score random: %s', round(mean(prf_out$score_random), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('Diff: %s', round(mean(prf_out$score_diff), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('Overlap 0: %s', 
            round(mean(length(which(prf_out$score_diff < 0))/length(prf_out$score_diff)), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('N: %s', round(mean(prf_out$N), 2)), sep="\n",append=TRUE)
cat(sprintf('Loadings: %s', paste(prf_out$most_important, collapse = ', ')), 
    sep="\n",append=TRUE)
## save
sink()
dev.off()


