# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 27-09-2021
# Date last modified: 27-09-2021
# Author: Simeon Q. Smeele
# Description: Running DTW on the traces of isolated contact calls. 
# source('ANALYSIS/CODE/00_run_methods/01_DTW_run.R')
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('tidyverse', 'dtw', 'parallel')
for(lib in libraries){
  if(! lib %in% installed.packages()) lapply(lib, install.packages)
  lapply(lib, require, character.only = TRUE)
}

# Clean R
rm(list=ls()) 

# Paths
source('ANALYSIS/CODE/paths.R')

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Load data
load(path_data)

# Which data sets make sense for DTW
loud_contact = data_sets$loud_contact
data_sets = data_sets[c('contact',
                        'short_contact', 'trruup', 
                        'kaw', 'tja')]

# Check if all loud contacts are also contact calls
if(!all(data_sets$loud_contact %in% data_sets$contact)) stop('Missing some loud contacts in contact!')

# Subset smooth traces to only include call types for which DTW makes sense
smooth_traces = smooth_traces[which(names(smooth_traces) %in% 
                                      unlist(data_sets))]

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Run DTW per dataset
m_list = lapply(data_sets, function(data_set) 
  run.dtw(smooth_traces[which(names(smooth_traces) %in% data_set)]))

# Add loud contact calls
m_list$loud_contact = m_list$contact[loud_contact, loud_contact]

# Save
save(m_list, file = path_dtw_m_list)

# Report
message(sprintf('Saved dtw results for %s data sets.', length(data_sets)))
