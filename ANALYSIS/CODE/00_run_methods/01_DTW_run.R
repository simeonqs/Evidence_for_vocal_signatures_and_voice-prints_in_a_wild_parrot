# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 27-09-2021
# Date last modified: 27-09-2021
# Author: Simeon Q. Smeele
# Description: Running DTW on the traces of isolated contact calls. 
# source('ANALYSIS/CODE/dtw/00_run_dtw.R')
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('data.table', 'tidyverse', 'warbleR', 'dtw', 'parallel')
for(lib in libraries){
  if(! lib %in% installed.packages()) lapply(lib, install.packages)
  lapply(lib, require, character.only = TRUE)
}

# Clean R
rm(list=ls()) 

# Paths
path_data = 'ANALYSIS/RESULTS/00_run_methods/all_data.RData'
path_functions = 'ANALYSIS/CODE/functions'
path_dtw_out = 'ANALYSIS/RESULTS/00_run_methods/dtw/m_list.RData'

# Load data
load(path_data)

# Which data sets make sense for DTW
data_sets = data_sets[c('contact', 'contact_mix', 
                        'short_contact', 'trruup', 
                        'kaw', 'tja', 'tjup', 
                        'tonal_mix')]

# Subset smooth traces to only include call types for which DTW makes sense
smooth_traces = smooth_traces[which(names(smooth_traces) %in% 
                                      unlist(data_sets))]

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Run DTW per dataset
m_list = lapply(data_sets, function(data_set) 
  run.dtw(smooth_traces[which(names(smooth_traces) %in% data_set)]))

# Save
save(m_list, file = path_dtw_out)

# Report
message(sprintf('Saved dtw results for %s data sets.', length(data_sets)))
