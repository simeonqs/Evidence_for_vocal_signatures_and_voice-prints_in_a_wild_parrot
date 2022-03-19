# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 18-03-2022
# Date last modified: 18-03-2022
# Author: Simeon Q. Smeele
# Description: Running cross correlation on the MFCC traces. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# DATA ----
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

# Settings
n_cores = 2

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# ANALYSIS
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Run mfcc
mfcc_objects = lapply(waves, mfcc.object)
names(mfcc_objects) = names(waves)

run.mfcccc = function(data_set, mfcc_objects){
  mfcc_objects_sub = mfcc_objects[data_set]
  c = combn(1:length(mfcc_objects_sub), 2)
  o = mclapply(1:ncol(c), function(i) 
    sliding.pixel.comparison(mfcc_objects_sub[[c[1,i]]], mfcc_objects_sub[[c[2,i]]]),
    mc.cores = n_cores) %>% unlist
  o = o/max(o)
  m = o.to.m(o, names(mfcc_objects_sub))
  rownames(m) = colnames(m) = data_set
  return(m)
}
m_list = lapply(data_sets, run.mfcccc, mfcc_objects)
names(m_list) = names(data_sets)

# Save
save(m_list, file = path_mfcccc_m_list)
message('Done.')
