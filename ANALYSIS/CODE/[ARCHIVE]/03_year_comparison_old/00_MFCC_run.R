# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 01-02-2022
# Date last modified: 01-02-2022
# Author: Simeon Q. Smeele
# Description: Running mfcc for the year data. 
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

# Merge data sets
types = c('contact', 'short_contact', 'trruup', 'tja', 'kaw', 'alarm', 'growl', 'growl_low')
data_sets = lapply(types, function(type) unlist(c(data_sets_20[type], data_sets_21[type])))
names(data_sets) = types
waves = append(waves_20, waves_21)

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# ANALYSIS
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Run mfcc
mfcc_out = lapply(waves, run.mfcc)
names(mfcc_out) = names(waves)

# Calculate distance matrices
## make sure this dist is correct - move function out and write unit tests
m_list = lapply(data_sets, function(data_set){
  mfcc_sub = mfcc_out[data_set] %>% bind_rows
  m = as.matrix(dist(scale(mfcc_sub)))
  rownames(m) = colnames(m) = data_set
  return(m)
} )

# Save
save(m_list, file = path_mfcc_year)
message('Done.')
