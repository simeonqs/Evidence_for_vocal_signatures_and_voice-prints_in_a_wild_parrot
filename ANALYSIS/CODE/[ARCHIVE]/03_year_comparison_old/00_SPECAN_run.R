# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 01-02-2022
# Date last modified: 01-02-2022
# Author: Simeon Q. Smeele
# Description: Loading the datasets and running specan on all calls across years.
# source('ANALYSIS/CODE/03_year_comparison/00_SPECAN_run.R')
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
types = c('contact', 'short_contact', 'trruup', 'tja', 'kaw', 'alarm', 'growl', 'growl_low')
data_sets = lapply(types, function(type) unlist(c(data_sets_20[type], data_sets_21[type])))
names(data_sets) = types
waves = append(waves_20, waves_21)

# Run specan
specan_out = mclapply(waves, specan.sim, mc.cores = 4)
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
save(m_list, file = path_specan_year)
message('Done.')
