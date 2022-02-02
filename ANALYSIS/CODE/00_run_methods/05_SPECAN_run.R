# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 19-10-2021
# Date last modified: 02-02-2022
# Author: Simeon Q. Smeele
# Description: Loading the datasets and running specan on all calls. Saving the distance matrices per 
# dataset. 
# This version was updated for the 2021 data. 
# This version also includes the 2020 data. 
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
source('ANALYSIS/CODE/paths.R')

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Load data 
load(path_data)
load(path_waves)

# Run specan
specan_out_20 = mclapply(waves_20, specan.sim, mc.cores = 4)
specan_out_20 = bind_rows(specan_out_20)
rownames(specan_out_20) = names(waves_20)
specan_out_21 = mclapply(waves_21, specan.sim, mc.cores = 4)
specan_out_21 = bind_rows(specan_out_21)
rownames(specan_out_21) = names(waves_21)

# Calculate distance matrices
m_list_20 = lapply(data_sets_20, function(data_set){   
  specan_sub = specan_out_20[data_set,]
  m = as.matrix(dist(scale(specan_sub)))
  rownames(m) = colnames(m) = data_set
  return(m)
} )
m_list_21 = lapply(data_sets_21, function(data_set){   
  specan_sub = specan_out_21[data_set,]
  m = as.matrix(dist(scale(specan_sub)))
  rownames(m) = colnames(m) = data_set
  return(m)
} )

# Save
save(m_list_20, m_list_21, file = path_specan_m_list)
message('Done.')