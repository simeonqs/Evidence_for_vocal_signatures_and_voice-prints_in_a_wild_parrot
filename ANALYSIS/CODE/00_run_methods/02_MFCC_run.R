# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 22-09-2021
# Date last modified: 18-01-2022
# Author: Simeon Q. Smeele
# Description: Running mfcc per call type and saving data as long distance for SN model. 
# This version saves objects together. 
# This version is updated for the 2021 data. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# DATA ----
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('data.table', 'tidyverse', 'warbleR')
for(i in libraries){
  if(! i %in% installed.packages()) lapply(i, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Clean R
rm(list=ls()) 

# Paths
path_audio = '/Volumes/Elements 4/BARCELONA_2021/audio'
path_data = 'ANALYSIS/RESULTS/00_run_methods/all_data.RData'
path_functions = 'ANALYSIS/CODE/functions'
path_out = 'ANALYSIS/RESULTS/00_run_methods/mfcc/m_list.RData'

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Load data
load(path_data)

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# ANALYSIS
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Load waves
waves = lapply(1:nrow(st), function(i){
  load.wave(path_audio_file = paste0(path_audio, '/', st$file[i], '.wav'), 
            from = st$Begin.Time..s.[i],
            to = st$End.Time..s.[i])
} 
  )


# Run mfcc
mfcc_out = lapply(waves, run.mfcc)

# Calculate distance matrices
## make sure this dist is correct - move function out and write unit tests
m_list = lapply(data_sets, function(data_set){
  mfcc_sub = mfcc_out[st$fs %in% data_set] %>% bind_rows
  return(as.matrix(dist(scale(mfcc_sub))))
} )

# Save
save(m_list, file = path_out)
message('Done.')
