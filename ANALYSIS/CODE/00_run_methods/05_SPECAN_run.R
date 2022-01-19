# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 19-10-2021
# Date last modified: 19-01-2022
# Author: Simeon Q. Smeele
# Description: Loading the datasets and running specan on all calls. Saving the distance matrices per 
# dataset. 
# This version was updated for the 2021 data. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('tidyverse', 'warbleR')
for(lib in libraries){
  if(! lib %in% installed.packages()) lapply(lib, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Clean R
rm(list=ls()) 

# Paths
path_functions = 'ANALYSIS/CODE/functions'
path_out = 'ANALYSIS/RESULTS/00_run_methods/specan/results.RData'
path_data = 'ANALYSIS/RESULTS/00_run_methods/all_data.RData'
path_waves = 'ANALYSIS/RESULTS/00_run_methods/waves.RData'
path_audio_files = 'ANALYSIS/DATA/audio'
  
# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Load data 
load(path_data)
load(path_waves)

# Run specan
specan_out = lapply(waves, specan.sim)
specan_out = bind_rows(specan_out)
specan_out$fs = st$fs

# Calculate distance matrices
## make sure this dist is correct - move function out and write unit tests
specan_dists = lapply(specan_out, function(x) as.matrix(dist(scale(x[,-1]))))

# Save
save(specan_out, specan_dists, data_sets, file = path_out)
message('Done.')