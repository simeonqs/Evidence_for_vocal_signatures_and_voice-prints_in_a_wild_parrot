# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: chapter II
# Date started: 26-08-2021
# Date last modified: 27-08-2021
# Author: Simeon Q. Smeele
# Description: Creating spec objects for all calls from 2020.
# This version adds the names to the spec_objects. 
# source('ANALYSIS/CODE/spcc/00_create_spec_objects.R')
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# DATA ----
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('tidyverse', 'warbleR', 'oce', 'signal')
for(i in libraries){
  if(! i %in% installed.packages()) lapply(i, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Clean R
rm(list=ls()) 

# Paths
path_functions = 'ANALYSIS/CODE/functions'
path_audio = 'ANALYSIS/DATA/audio'
path_selection_tables = 'ANALYSIS/DATA/selection tables'
path_annotations = 'ANALYSIS/DATA/overview recordings/annotations.csv'
path_spec_objects = 'ANALYSIS/RESULTS/spcc/spec_objects.RData'

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Audio files 
audio_files = list.files(path_audio,  '*wav', full.names = T)

# Load selection tables
dat = load.selection.tables(path_selection_tables, path_annotations)

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# ANALYSIS: ----
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Generate spec_ojects
spec_objects = sapply(1:nrow(dat), function(i){
  new_dat = dat[i,]
  file = audio_files[str_detect(audio_files, new_dat$file)]
  wave = readWave(file, from = new_dat$Begin.Time..s., to = new_dat$End.Time..s., units = 'seconds')
  if(max(abs(wave@left)) == 32768) wave@left = wave@right # if clipping use right channel
  wave = ffilter(wave, from = 500, output = 'Wave')
  spec_oject = cutted.spectro(wave, freq_range = c(1000, 6000), plot_it = F, 
                              thr_low = 1.1, thr_high = 1.8,
                              wl = 512, ovl = 450, 
                              method = 'sd',
                              sum_one = T)
  return(spec_oject)
})

# Plot example
image(t(spec_objects[[1]]), col = hcl.colors(12, 'Blue-Yellow', rev = T)) 

# Save spec_objects
names(spec_objects) = paste(dat$file, dat$Selection, sep = '-')
save(spec_objects, file = path_spec_objects)