# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: chapter II
# Date started: 26-08-2021
# Date last modified: 26-08-2021
# Author: Simeon Q. Smeele
# Description: Running pixel comparison on all calls from 2020. 
# source('ANALYSIS/CODE/spcc/01_run_pixel_comparison.R')
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('tidyverse', 'parallel')
for(i in libraries){
  if(! i %in% installed.packages()) lapply(i, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Clean R
rm(list=ls()) 

# Settings
n_cores = 40

# Paths
path_functions = 'ANALYSIS/CODE/functions'
path_spec_objects = 'ANALYSIS/RESULTS/spcc/spec_objects.RData'
path_o = 'ANALYSIS/RESULTS/spcc/o.RData'

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Load data 
load(path_spec_objects)

# Get combinations and run function
c = combn(1:length(spec_objects), 2)
o = mclapply(1:ncol(c), function(i) sliding.pixel.comparison(spec_objects[[c[1,i]]], spec_objects[[c[2,i]]]),
             mc.cores = n_cores) %>% unlist
o = o/max(o)
save(o, file = path_o)