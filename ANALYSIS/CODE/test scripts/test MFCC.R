# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 25-01-2022
# Date last modified: 28-02-2022
# Author: Simeon Q. Smeele
# Description: Test if the mfcc output is correct. 
# This version includes the 2020 data. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('tidyverse', 'parallel')
for(lib in libraries){
  if(! lib %in% installed.packages()) lapply(lib, install.packages)
  lapply(lib, require, character.only = TRUE)
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
load(path_mfcc_m_list)

# Choose the year
waves = waves_20
smooth_traces = smooth_traces_20
st = st_20
data_sets = data_sets_20
m_list = m_list_20
path_audio = path_audio_20

# Plot most extreme case per call type
pdf(path_pdf_test_mfcc)
for(type in names(m_list)){
  m = m_list[[type]]
  rs = rowSums(m)
  the_ones = rownames(m)[order(rs, decreasing = T)][1:10]
  for(one in the_ones){
    i = which(st$fs == one)
    start = st$Begin.Time..s.[i] - 0.05
    end = st$End.Time..s.[i] + 0.05
    wave = load.wave(path_audio_file = paste0(path_audio, '/', st$file[i], '.wav'), 
                     from = start,
                     to = end)
    better.spectro(wave, main = paste(type, st$fs[i]), ylim = c(0, 6000), ovl = 400)
    abline(v = c(0.05, end-start-0.05), lty = 2, lwd = 3, col = alpha(1, 0.5))
  }
}
dev.off()
