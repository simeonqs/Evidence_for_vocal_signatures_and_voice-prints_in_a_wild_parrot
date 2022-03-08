# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 30-01-2022
# Date last modified: 30-01-2022
# Author: Simeon Q. Smeele
# Description: Running DTW for the year comparison. 
# source('ANALYSIS/CODE/03_year_comparison/00_DTW_run.R')
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
set.seed(1)
types = c('contact', 'loud_contact', 'short_contact', 'trruup', 'tja', 'kaw') # 'alarm', 'growl', 'growl_low')

data_sets = lapply(types, function(type) unlist(c(data_sets_20[type], data_sets_21[type])))
names(data_sets) = types

# Merge the smooth traces
smooth_traces = c(smooth_traces_20, smooth_traces_21)

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Run DTW per dataset
m_list = lapply(data_sets, function(data_set) 
  run.dtw(smooth_traces[which(names(smooth_traces) %in% data_set)]))

# Save
save(m_list, file = path_dtw_year)

# Report
message('Saved dtw results.')
