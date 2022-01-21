# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: chapter II
# Date started: 26-08-2021
# Date last modified: 19-01-2022
# Author: Simeon Q. Smeele
# Description: Creating spec objects for all calls from 2020.
# This version adds the names to the spec_objects. 
# This version is updated for the 2021 data. 
# This version moves out the reading of the waves. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# DATA ----
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('tidyverse', 'warbleR', 'oce', 'signal')
for(lib in libraries){
  if(! lib %in% installed.packages()) lapply(lib, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Clean R
rm(list=ls()) 

# Paths
path_functions = 'ANALYSIS/CODE/functions'
path_data = 'ANALYSIS/RESULTS/00_run_methods/all_data.RData'
path_spec_objects = 'ANALYSIS/RESULTS/00_run_methods/spcc/spec_objects.RData'
path_waves = 'ANALYSIS/RESULTS/00_run_methods/waves.RData'

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Load data
load(path_data)
load(path_waves)

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# ANALYSIS: ----
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Generate spec_ojects
spec_objects = sapply(waves, function(wave){
  wave = ffilter(wave, from = 500, output = 'Wave')
  spec_oject = cutted.spectro(wave, freq_range = c(1000, 4000), plot_it = F, 
                              thr_low = 1.1, thr_high = 1.8,
                              wl = 512, ovl = 450, 
                              method = 'sd',
                              sum_one = T)
  return(spec_oject)
})

# Plot example
image(t(spec_objects[[1]]), col = hcl.colors(12, 'Blue-Yellow', rev = T)) 

# Save spec_objects
names(spec_objects) = names(waves)
save(spec_objects, file = path_spec_objects)
