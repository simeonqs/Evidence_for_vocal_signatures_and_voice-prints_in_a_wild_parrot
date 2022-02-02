# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: chapter II
# Date started: 26-08-2021
# Date last modified: 02-02-2022
# Author: Simeon Q. Smeele
# Description: Running pixel comparison on all calls from 2020. 
# Note: This script takes a long time. Best to run on HPC and use many cores.
# Updates:
# This version adds the file_sels to the o object. 
# This version is updated to run with the 2021 data and run smoother. 
# This version is updates to include the 2020 data. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('tidyverse', 'parallel')
for(lib in libraries){
  if(! lib %in% installed.packages()) lapply(lib, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Clean R
rm(list=ls()) 

# Settings
n_cores = 40

# Paths
source('ANALYSIS/CODE/paths.R')

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Load data 
load(path_spec_objects)
load(path_data)

# Get combinations and run function
run.spcc = function(data_set, spec_objects){
  spec_objects_sub = spec_objects[data_set]
  c = combn(1:length(spec_objects_sub), 2)
  o = mclapply(1:ncol(c), function(i) 
    sliding.pixel.comparison(spec_objects_sub[[c[1,i]]], spec_objects_sub[[c[2,i]]]),
    mc.cores = n_cores) %>% unlist
  o = o/max(o)
  m = o.to.m(o, names(spec_objects_sub))
  rownames(m) = colnames(m) = data_set
  return(m)
}
m_list_20 = lapply(data_sets_20, run.spcc, spec_objects_20)
names(m_list_20) = names(data_sets_20)
m_list_21 = lapply(data_sets_21, run.spcc, spec_objects_21)
names(m_list_21) = names(data_sets_21)

# Save
save(m_list_20, m_list_21, file = path_spcc_m_list)
message('Done!')