# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 06-02-2022
# Date last modified: 29-07-2023
# Author: Simeon Q. Smeele
# Description: Running DFA.  
# This version also takes recording into account. 
# This version moves code to functions and iterates. 
# This version has additional testing code. 
# This version uses the combined dataset and removes the code for 2020. 
# This version is cleaned up. 
# This version also stores the results for the table. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('tidyverse', 'warbleR', 'MASS', 'rethinking')
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

# Run full pDFAs
## pdf
pdf(path_pdf_pdfa, 7, 7)
par(mfrow = c(2, 2))
## txt
sink(path_dfa_output)
## contact to contact
pdfa_contact = run.pdfa(train_set = 'contact', 
                    N_train = 40, N_test = 5,
                    test_set = 'contact', 
                    main = 'contact to contact',
                    mfcc_out = mfcc_out, st = st)
cat("-------------------------------------------------------------------------", sep="\n",append=TRUE)
cat("Contact to contact", sep="\n",append=TRUE)
cat(sprintf('Score trained: %s', round(mean(pdfa_contact$score), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('Score random: %s', round(mean(pdfa_contact$score_random), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('Diff: %s', round(mean(pdfa_contact$score_diff), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('Overlap 0: %s', 
            round(mean(length(which(pdfa_contact$score_diff < 0))/length(pdfa_contact$score_diff)), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('N: %s', round(mean(pdfa_contact$N), 2)), sep="\n",append=TRUE)
cat(sprintf('Loadings: %s', paste(pdfa_contact$most_important, collapse = ', ')), 
    sep="\n",append=TRUE)
## tonal to growly
pdfa_tonal_growly = run.pdfa(train_set = c('contact', 'tja', 'tjup', 'frill', 'other_tonal', 'short_contact',
                                  'kaw'), 
                    test_set = c('growl', 'alarm', 'growl_low', 'trruup'),
                    N_train = 40, N_test = 5,
                    main = 'tonal to growly',
                    mfcc_out = mfcc_out, st = st)
cat("-------------------------------------------------------------------------", sep="\n",append=TRUE)
cat("Tonal to growly", sep="\n",append=TRUE)
cat(sprintf('Score trained: %s', round(mean(pdfa_tonal_growly$score), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('Score random: %s', round(mean(pdfa_tonal_growly$score_random), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('Diff: %s', round(mean(pdfa_tonal_growly$score_diff), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('Overlap 0: %s', 
            round(mean(length(which(pdfa_tonal_growly$score_diff < 0))/
                         length(pdfa_tonal_growly$score_diff)), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('N: %s', round(mean(pdfa_tonal_growly$N), 2)), sep="\n",append=TRUE)
cat(sprintf('Loadings: %s', paste(pdfa_tonal_growly$most_important, collapse = ', ')), 
    sep="\n",append=TRUE)
## growly to tonal
pdfa_out_growly_tonal = run.pdfa(train_set = c('growl', 'alarm', 'growl_low', 'trruup'), 
                                 test_set = c('contact', 'tja', 'tjup', 'frill', 'other_tonal', 
                                              'short_contact', 'kaw'),
                                 N_train = 20, N_test = 5,
                                 main = 'growly to tonal',
                                 mfcc_out = mfcc_out, st = st)
cat("-------------------------------------------------------------------------", sep="\n",append=TRUE)
cat("Growly to tonal", sep="\n",append=TRUE)
cat(sprintf('Score trained: %s', round(mean(pdfa_out_growly_tonal$score), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('Score random: %s', round(mean(pdfa_out_growly_tonal$score_random), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('Diff: %s', round(mean(pdfa_out_growly_tonal$score_diff), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('Overlap 0: %s', 
            round(mean(length(which(pdfa_out_growly_tonal$score_diff < 0))/
                         length(pdfa_out_growly_tonal$score_diff)), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('N: %s', round(mean(pdfa_out_growly_tonal$N), 2)), sep="\n",append=TRUE)
cat(sprintf('Loadings: %s', paste(pdfa_out_growly_tonal$most_important, collapse = ', ')), 
    sep="\n",append=TRUE)
## all to all
pdfa_out_all = run.pdfa(train_set = c('contact', 'tja', 'tjup', 'frill', 'other_tonal', 'short_contact',
                                      'kaw', 'growl', 'alarm', 'growl_low', 'trruup'), 
                        test_set = c('contact', 'tja', 'tjup', 'frill', 'other_tonal', 'short_contact',
                                     'kaw', 'growl', 'alarm', 'growl_low', 'trruup'),
                        N_train = 20, N_test = 5,
                        main = 'all to all',
                        mfcc_out = mfcc_out, st = st)
cat("-------------------------------------------------------------------------", sep="\n",append=TRUE)
cat("All to all", sep="\n",append=TRUE)
cat(sprintf('Score trained: %s', round(mean(pdfa_out_all$score), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('Score random: %s', round(mean(pdfa_out_all$score_random), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('Diff: %s', round(mean(pdfa_out_all$score_diff), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('Overlap 0: %s', 
            round(mean(length(which(pdfa_out_all$score_diff < 0))/length(pdfa_out_all$score_diff)), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('N: %s', round(mean(pdfa_out_all$N), 2)), sep="\n",append=TRUE)
cat(sprintf('Loadings: %s', paste(pdfa_out_all$most_important, collapse = ', ')), 
    sep="\n",append=TRUE)
## save
sink()
dev.off()

# Save as RData file for table
pdfa_full = data.frame(sub_set = 'combined',
                       call_type = c('contact', 'tonal-growly', 'growly-tonal', 'all'),
                       mean_difference = c(round(mean(pdfa_contact$score_diff), 2),
                                           round(mean(pdfa_tonal_growly$score_diff), 2),
                                           round(mean(pdfa_out_growly_tonal$score_diff), 2),
                                           round(mean(pdfa_out_all$score_diff), 2)),
                       lower_bound = c(round(PI(pdfa_contact$score_diff)[1], 2),
                                       round(PI(pdfa_tonal_growly$score_diff)[1], 2),
                                       round(PI(pdfa_out_growly_tonal$score_diff)[1], 2),
                                       round(PI(pdfa_out_all$score_diff)[1], 2)),
                       upper_bound = c(round(PI(pdfa_contact$score_diff)[2], 2),
                                       round(PI(pdfa_tonal_growly$score_diff)[2], 2),
                                       round(PI(pdfa_out_growly_tonal$score_diff)[2], 2),
                                       round(PI(pdfa_out_all$score_diff)[2], 2)),
                       overlap_zero = c(round(mean(length(which(pdfa_contact$score_diff < 0))/
                                                     length(pdfa_contact$score_diff)), 2),
                                        round(mean(length(which(pdfa_tonal_growly$score_diff < 0))/
                                                     length(pdfa_tonal_growly$score_diff)), 2),
                                        round(mean(length(which(pdfa_out_growly_tonal$score_diff < 0))/
                                                     length(pdfa_out_growly_tonal$score_diff)), 2),
                                        round(mean(length(which(pdfa_out_all$score_diff < 0))/
                                                     length(pdfa_out_all$score_diff)), 2)),
                       sample_size = c(median(pdfa_contact$N),
                                       median(pdfa_tonal_growly$N),
                                       median(pdfa_out_growly_tonal$N),
                                       median(pdfa_out_all$N)))
save(pdfa_full, file = path_pdfa_full)

# Make plots for paper
pdf(path_pdf_pdfa_paper_1, 5, 3)
par(bg = NA, oma = rep(0, 4), mar = rep(0, 4))
plot(density(pdfa_tonal_growly$score_diff), lwd = 6, col = '#929292', main = '',
     xlab = '', ylab = '', xlim = c(-0.2, 0.5), xaxt = 'n', yaxt = 'n', bty = 'n')
dev.off()

# Make plots for paper
pdf(path_pdf_pdfa_paper_2, 5, 3)
par(bg = NA, oma = rep(0, 4), mar = rep(0, 4))
plot(density(pdfa_out_all$score_diff), lwd = 6, col = '#929292', main = '',
     xlab = '', ylab = '', xlim = c(-0.2, 0.5), xaxt = 'n', yaxt = 'n', bty = 'n')
dev.off()
