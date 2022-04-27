# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 07-03-2022
# Date last modified: 07-03-2022
# Author: Simeon Q. Smeele
# Description: Running specan per call type and saving data for DFA. 
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

# Run specan
message(sprintf('Running specan on %s waves...', length(waves)))
specan_out = lapply(waves, run.specan)
message(sprintf('Running specan on %s waves...', length(waves_20)))
specan_out_20 = lapply(waves_20, run.specan)
message(sprintf('Running specan on %s waves...', length(waves_21)))
specan_out_21 = lapply(waves_21, run.specan)

# Save
save(specan_out, specan_out_20, specan_out_21, file = path_specan_out)
message('Done.')