# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 27-09-2021
# Date last modified: 02-02-2022
# Author: Simeon Q. Smeele
# Description: Running DTW on the traces of isolated contact calls. 
# This version includes the 2020 data as well. 
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
loud_contact = data_sets_21$loud_contact
data_sets_20 = data_sets_20[c('contact',
                              'short_contact', 'trruup', 
                              'kaw', 'tja')]
data_sets_21 = data_sets_21[c('contact',
                              'short_contact', 'trruup', 
                              'kaw', 'tja')]

# Check if all loud contacts are also contact calls
if(!all(data_sets_21$loud_contact %in% data_sets_21$contact)) stop('Missing some loud contacts in contact!')

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Run DTW per dataset
m_list_20 = lapply(data_sets_20, function(data_set) 
  run.dtw(smooth_traces_20[which(names(smooth_traces_20) %in% data_set)]))
m_list_21 = lapply(data_sets_21, function(data_set) 
  run.dtw(smooth_traces_21[which(names(smooth_traces_21) %in% data_set)]))

# Add loud contact calls
m_list_21$loud_contact = m_list_21$contact[loud_contact, loud_contact]

# Save
save(m_list_20, m_list_21, file = path_dtw_m_list)

# Report
message('Saved dtw results.')