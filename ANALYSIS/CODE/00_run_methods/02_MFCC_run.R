# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 22-09-2021
# Date last modified: 02_02-2022
# Author: Simeon Q. Smeele
# Description: Running mfcc per call type and saving data as long distance for SN model. 
# This version saves objects together. 
# This version is updated for the 2021 data. 
# This version moves out the reading of the waves. 
# This version also includes the 2020 data. 
# source('ANALYSIS/CODE/00_run_methods/02_MFCC_run.R')
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# DATA ----
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
load(path_data)
load(path_waves)

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# ANALYSIS
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Run mfcc
mfcc_out_20 = lapply(waves_20, run.mfcc)
names(mfcc_out_20) = names(waves_20)
mfcc_out_21 = lapply(waves_21, run.mfcc)
names(mfcc_out_21) = names(waves_21)

# Calculate distance matrices
## make sure this dist is correct - move function out and write unit tests
m_list_20 = lapply(data_sets_20, function(data_set){
  mfcc_sub = mfcc_out_20[data_set] %>% bind_rows
  m = as.matrix(dist(scale(mfcc_sub)))
  rownames(m) = colnames(m) = data_set
  return(m)
} )
m_list_21 = lapply(data_sets_21, function(data_set){
  mfcc_sub = mfcc_out_21[data_set] %>% bind_rows
  m = as.matrix(dist(scale(mfcc_sub)))
  rownames(m) = colnames(m) = data_set
  return(m)
} )

# Save
save(m_list_20, m_list_21, file = path_mfcc_m_list)
message('Done.')
