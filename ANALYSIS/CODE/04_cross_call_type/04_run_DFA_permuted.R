# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 06-02-2022
# Date last modified: 14-05-2022
# Author: Simeon Q. Smeele
# Description: Running DFA. Permuting randomisation within locations. 
# This version adds the area for the 2020 birds. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('tidyverse', 'warbleR', 'MASS')
for(i in libraries){
  if(! i %in% installed.packages()) lapply(i, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Clean R
rm(list=ls()) 
set.seed(1)

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

# Load location data, add to st and subset for known
nesting_20 = read.csv2(path_nesting_20)
nesting_20 = nesting_20[!is.na(nesting_20$tree_manual),]
nest_overview_20 = read.csv2(path_nesting_overview_20)
nesting_20$area = sapply(nesting_20$tree_manual, function(tree){
  area = nest_overview_20$cluster[which(nest_overview_20$tree == tree)]
  if(length(area) != 1) return(NA) else return(area)
})
nesting_21 = read.csv2(path_nesting_21)
nesting = na.omit(rbind(nesting_20[,c('id', 'area')], nesting_21[,c('id', 'area')]))
st$nesting = sapply(st$bird, function(bird){
  area = nesting$area[nesting$id == bird]
  if(length(area) == 0) return(NA) else 
    if(any(str_detect(area, 'square'))) 
      return('square') else 
        return('park')
})
st = st[!is.na(st$nesting),]
mfcc_out = mfcc_out[st$fs]

# Run full pDFAs
## pdf
pdf(path_pdf_pdfa_permuted, 7, 7)
par(mfrow = c(2, 2))
## txt
sink(path_dfa_output_permuted)
## contact to contact
pdfa_out = run.pdfa(train_set = 'contact', 
                    N_train = 30, N_test = 3,
                    test_set = 'contact', 
                    main = 'contact to contact',
                    mfcc_out = mfcc_out, st = st,
                    permute = T)
cat("-------------------------------------------------------------------------", sep="\n",append=TRUE)
cat("Contact to contact", sep="\n",append=TRUE)
cat(sprintf('Score trained: %s', round(mean(pdfa_out$score), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('Score random: %s', round(mean(pdfa_out$score_random), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('Diff: %s', round(mean(pdfa_out$score_diff), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('Overlap 0: %s', 
            round(mean(length(which(pdfa_out$score_diff < 0))/length(pdfa_out$score_diff)), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('N: %s', round(mean(pdfa_out$N), 2)), sep="\n",append=TRUE)
cat(sprintf('Loadings: %s', paste(pdfa_out$most_important, collapse = ', ')), 
    sep="\n",append=TRUE)
## tonal to growly
pdfa_out = run.pdfa(train_set = c('contact', 'tja', 'tjup', 'frill', 'other_tonal', 'short_contact',
                                  'kaw'), 
                    test_set = c('growl', 'alarm', 'growl_low', 'trruup'),
                    N_train = 30, N_test = 3,
                    main = 'tonal to growly',
                    mfcc_out = mfcc_out, st = st,
                    permute = T)
cat("-------------------------------------------------------------------------", sep="\n",append=TRUE)
cat("Tonal to growly", sep="\n",append=TRUE)
cat(sprintf('Score trained: %s', round(mean(pdfa_out$score), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('Score random: %s', round(mean(pdfa_out$score_random), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('Diff: %s', round(mean(pdfa_out$score_diff), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('Overlap 0: %s', 
            round(mean(length(which(pdfa_out$score_diff < 0))/length(pdfa_out$score_diff)), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('N: %s', round(mean(pdfa_out$N), 2)), sep="\n",append=TRUE)
cat(sprintf('Loadings: %s', paste(pdfa_out$most_important, collapse = ', ')), 
    sep="\n",append=TRUE)
## growly to tonal
pdfa_out = run.pdfa(train_set = c('growl', 'alarm', 'growl_low', 'trruup'), 
                    test_set = c('contact', 'tja', 'tjup', 'frill', 'other_tonal', 'short_contact',
                                 'kaw'),
                    N_train = 20, N_test = 5,
                    main = 'growly to tonal',
                    mfcc_out = mfcc_out, st = st,
                    permute = T)
cat("-------------------------------------------------------------------------", sep="\n",append=TRUE)
cat("Growly to tonal", sep="\n",append=TRUE)
cat(sprintf('Score trained: %s', round(mean(pdfa_out$score), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('Score random: %s', round(mean(pdfa_out$score_random), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('Diff: %s', round(mean(pdfa_out$score_diff), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('Overlap 0: %s', 
            round(mean(length(which(pdfa_out$score_diff < 0))/length(pdfa_out$score_diff)), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('N: %s', round(mean(pdfa_out$N), 2)), sep="\n",append=TRUE)
cat(sprintf('Loadings: %s', paste(pdfa_out$most_important, collapse = ', ')), 
    sep="\n",append=TRUE)
## all to all
pdfa_out = run.pdfa(train_set = c('contact', 'tja', 'tjup', 'frill', 'other_tonal', 'short_contact',
                                  'kaw', 'growl', 'alarm', 'growl_low', 'trruup'), 
                    test_set = c('contact', 'tja', 'tjup', 'frill', 'other_tonal', 'short_contact',
                                 'kaw', 'growl', 'alarm', 'growl_low', 'trruup'),
                    N_train = 20, N_test = 3,
                    main = 'all to all',
                    mfcc_out = mfcc_out, st = st,
                    permute = T)
cat("-------------------------------------------------------------------------", sep="\n",append=TRUE)
cat("All to all", sep="\n",append=TRUE)
cat(sprintf('Score trained: %s', round(mean(pdfa_out$score), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('Score random: %s', round(mean(pdfa_out$score_random), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('Diff: %s', round(mean(pdfa_out$score_diff), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('Overlap 0: %s', 
            round(mean(length(which(pdfa_out$score_diff < 0))/length(pdfa_out$score_diff)), 2)), 
    sep="\n",append=TRUE)
cat(sprintf('N: %s', round(mean(pdfa_out$N), 2)), sep="\n",append=TRUE)
cat(sprintf('Loadings: %s', paste(pdfa_out$most_important, collapse = ', ')), 
    sep="\n",append=TRUE)
## save
sink()
dev.off()