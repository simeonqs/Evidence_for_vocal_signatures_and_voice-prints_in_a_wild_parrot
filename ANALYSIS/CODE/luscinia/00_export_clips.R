# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: chapter II  
# Date started: 26-08-2021
# Date last modified: 26-08-2021
# Author: Simeon Q. Smeele
# Description: This script takes the raw output of Luscinia for the contact calls, smoothens the traces, 
# runs dtw and outputs the results for the next step. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# DATA ----
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('data.table', 'tidyverse', 'warbleR', 'dtw', 'labdsv', 'parallel', 'umap', 'oce', 'signal',
              'readxl', 'rethinking')
for(lib in libraries){
  if(! lib %in% installed.packages()) lapply(lib, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Clean R
rm(list=ls()) 

# Paths
path_functions = 'ANALYSIS/CODE/functions'
path_traces = 'ANALYSIS/DATA/luscinia/all contact.csv'
path_out = 'ANALYSIS/RESULTS/luscinia/clips'
path_selection_tables = 'ANALYSIS/DATA/selection tables'
path_annotations = 'ANALYSIS/DATA/overview recordings/annotations.csv'
path_context = 'ANALYSIS/DATA/overview recordings/call types.xlsx'
path_audio = 'ANALYSIS/DATA/audio'

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Load data
st = load.selection.tables(path_selection_tables, path_annotations, path_context)
traces = load.traces(path_traces)
audio_files = list.files(path_audio,  '*wav', full.names = T)

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# ANALYSIS ----
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Split data into:
  # contact - trace f0
  # tonal - trace f1
  # other - trace only for time

# Contact
stc = st[which(str_detect(st$`call type`, 'contact')),]
stc = stc[which(!stc$fs %in% str_remove(traces$Song, '.wav')),]

# Export
for(i in 1:nrow(stc)){
  
  # Subset
  new_dat = stc[i,]
  
  # Choose start and end
  start = new_dat$Begin.Time..s.
  end = new_dat$End.Time..s.
  
  # Read file
  file = audio_files[str_detect(audio_files, new_dat$file)]
  wave = readWave(file, from = start, to = end, units = 'seconds')
  
  # Save
  writeWave(wave, sprintf('%s/contact/%s.wav', path_out, new_dat$fs), extensible = F) 
  
}





