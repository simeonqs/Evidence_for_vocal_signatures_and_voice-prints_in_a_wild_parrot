# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 19-10-2021
# Date last modified: 24-01-2022
# Author: Simeon Q. Smeele
# Description: Loading the datasets and running specan on all calls. Saving the distance matrices per 
# dataset. 
# This version was updated for the 2021 data. 
# source('ANALYSIS/CODE/00_run_methods/05_SPECAN_run.R')
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
path_out = 'ANALYSIS/RESULTS/00_run_methods/specan/m_list.RData'
path_data = 'ANALYSIS/RESULTS/00_run_methods/all_data.RData'
path_waves = 'ANALYSIS/RESULTS/00_run_methods/waves.RData'

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Load data 
load(path_data)
load(path_waves)

# Run specan
specan_out = lapply(waves, specan.sim)
specan_out = bind_rows(specan_out)
rownames(specan_out) = names(waves)

# Calculate distance matrices
m_list = lapply(data_sets, function(data_set){   
  specan_sub = specan_out[data_set,]
  m = as.matrix(dist(scale(specan_sub)))
  rownames(m) = colnames(m) = data_set
  return(m)
} )

# Save
save(m_list, file = path_out)
message('Done.')
