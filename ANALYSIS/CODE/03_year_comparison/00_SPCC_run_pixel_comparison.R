# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: chapter II
# Date started: 31-01-2022
# Date last modified: 31-01-2022
# Author: Simeon Q. Smeele
# Description: Running pixel comparison on all calls from both years. 
# Note: This script takes a long time. Best to run on HPC and use many cores.
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
path_functions = 'ANALYSIS/CODE/functions'
path_spec_objects = 'ANALYSIS/RESULTS/00_run_methods/spcc/spec_objects.RData'
path_out = 'ANALYSIS/RESULTS/03_year_comparison/spcc/m_list.RData'
path_data = 'ANALYSIS/RESULTS/00_run_methods/all_data.RData'

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Load data 
load(path_spec_objects)
load(path_data)

# Combine data sets
types = c('contact', 'short_contact', 'trruup', 'tja', 'kaw', 'alarm', 'growl', 'growl_low')
data_sets = lapply(types, function(type) unlist(c(data_sets_20[type], data_sets_21[type])))
names(data_sets) = types

# Get combinations and run function
m_list = lapply(data_sets, function(data_set){
  
  spec_objects_sub = spec_objects[data_set]
  c = combn(1:length(spec_objects_sub), 2)
  o = mclapply(1:ncol(c), function(i) 
    sliding.pixel.comparison(spec_objects_sub[[c[1,i]]], spec_objects_sub[[c[2,i]]]),
               mc.cores = n_cores) %>% unlist
  o = o/max(o)
  m = o.to.m(o, names(spec_objects_sub))
  rownames(m) = colnames(m) = data_set
  return(m)
  
})

names(m_list) = names(data_sets)

# Save
save(m_list, file = path_out)
message('Done!')