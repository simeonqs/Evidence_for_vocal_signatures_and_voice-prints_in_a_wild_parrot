# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 06-02-2022
# Date last modified: 03-03-2022
# Author: Simeon Q. Smeele
# Description: Running mfcc per call type and saving data for DFA. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('tidyverse', 'warbleR')
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
load(path_waves)

# Merge datasets
waves = append(waves_20, waves_21)

# Run mfcc
message(sprintf('Running mfcc on %s waves...', length(waves)))
mfcc_out = lapply(waves, run.mfcc, numcep = 15)
message(sprintf('Running mfcc on %s waves...', length(waves_20)))
mfcc_out_20 = lapply(waves_20, run.mfcc, numcep = 15)
message(sprintf('Running mfcc on %s waves...', length(waves_21)))
mfcc_out_21 = lapply(waves_21, run.mfcc, numcep = 15)

# Save
save(mfcc_out, mfcc_out_20, mfcc_out_21, file = path_mfcc_out)
message('Done.')