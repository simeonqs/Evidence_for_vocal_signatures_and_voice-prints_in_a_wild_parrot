# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 26-01-2022
# Date last modified: 26-01-2022
# Author: Simeon Q. Smeele
# Description: Clipping all calls from 2020 that are mising and saving as wavs for Luscinia traces. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# DATA ----
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('data.table', 'tidyverse', 'warbleR')
for(lib in libraries){
  if(! lib %in% installed.packages()) lapply(lib, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Load functions
.functions = sapply(list.files('ANALYSIS/CODE/functions', pattern = '*.R', full.names = T), source)

# Paths
source('ANALYSIS/CODE/paths.R')
path_out = 'ANALYSIS/RESULTS/luscinia/clips_2020'
path_audio_2020 = '/Volumes/Elements 4/BARCELONA_2020/audio'

# Load data
dat = load.selection.tables(path_selection_tables)
traces = load.traces(path_traces_2020)

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# ANALYSIS ----
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Subset dat
dat = dat[str_detect(dat$file, '2020'),]
dat = dat[!dat$fs %in% str_remove(traces$Song, '.wav'),]

# Looping through the files
audio_files = list.files(path_audio_2020, '*wav', full.names = T)
for(i in 1:nrow(dat)){
  
  # Subset
  new_dat = dat[i,]
  
  # Choose start and end
  start = new_dat$Begin.Time..s.
  end = new_dat$End.Time..s.
  
  # Read file
  file = audio_files[str_detect(audio_files, new_dat$file)]
  if(length(file) == 0){print(new_dat$file); next}
  wave = readWave(file, from = start, to = end, units = 'seconds')
  
  # Create new name 
  new_name = sprintf('%s/%s-%s.wav', path_out, new_dat$file, new_dat$Selection)
  
  # Save
  writeWave(wave, new_name, extensible = F) 
  
}



