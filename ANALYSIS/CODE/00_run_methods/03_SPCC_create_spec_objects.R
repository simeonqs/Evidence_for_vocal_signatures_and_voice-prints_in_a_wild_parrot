# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: chapter II
# Date started: 26-08-2021
# Date last modified: 31-01-2022
# Author: Simeon Q. Smeele
# Description: Creating spec objects for all calls from 2020.
# This version adds the names to the spec_objects. 
# This version is updated for the 2021 data. 
# This version moves out the reading of the waves. 
# This version was updated to include the 2020 data as well. 
# source('ANALYSIS/CODE/00_run_methods/03_SPCC_create_spec_objects.R')
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
source('ANALYSIS/CODE/paths.R')

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Load data
load(path_data)
load(path_waves)

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# ANALYSIS: ----
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Function to create spec objects
create.spec.objects = function(waves){
  message(sprintf('Starting processing of %s wave objects...', length(waves)))
  spec_objects = sapply(waves, function(wave){
    wave = ffilter(wave, from = 500, output = 'Wave')
    spec_oject = cutted.spectro(wave, freq_range = c(1000, 3000), plot_it = F, 
                                thr_low = 1.1, thr_high = 1.8,
                                wl = 512, ovl = 450, 
                                method = 'sd',
                                sum_one = T)
    return(spec_oject)
  })
  names(spec_objects) = names(waves)
  message('Done!')
  return(spec_objects)
}

# Generate spec_ojects
spec_objects_20 = create.spec.objects(waves_20)
spec_objects_21 = create.spec.objects(waves_21)

# Plot example
image(t(spec_objects_20[[1]]), col = hcl.colors(12, 'Blue-Yellow', rev = T)) 

# Save spec_objects
save(spec_objects_20, spec_objects_21, file = path_spec_objects)
message('All objects are saved.')