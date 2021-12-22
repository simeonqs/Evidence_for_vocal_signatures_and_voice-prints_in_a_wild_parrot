# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 27-08-2021
# Date last modified: 27-09-2021
# Author: Simeon Q. Smeele
# Description: Creates a dataset per call type including the subsetted distance matrix from spcc, and a 
# data.frame with file, file_sel, and ind. 
# This version uses the preprocessed datasets. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('tidyverse')
for(lib in libraries){
  if(! lib %in% installed.packages()) lapply(lib, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Clean R
rm(list=ls()) 

# Paths
path_functions = 'ANALYSIS/CODE/functions'
path_o = 'ANALYSIS/RESULTS/00_run_methods/spcc/o_with_names.RData'
path_data_sets = 'ANALYSIS/RESULTS/00_run_methods/data_sets.RData'
path_out = 'ANALYSIS/RESULTS/00_run_methods/spcc/results.RData'

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Load data 
load(path_data_sets)
load(path_o)

# Create dist mat
m = o.to.m(o_with_names$o, o_with_names$file_sels)
names(m) = o_with_names$file_sels

# Subset
spcc_dists = lapply(data_sets, function(data_set) m[data_set$fs, data_set$fs])
names(spcc_dists) = names(data_sets)

# Save
save(spcc_dists, data_sets, file = path_out)
message('Done.')
