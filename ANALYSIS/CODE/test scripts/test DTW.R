# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 25-01-2022
# Date last modified: 01-04-2022
# Author: Simeon Q. Smeele
# Description: Test if the traces and dtw output are correct. 
# This version includes the 2020 data. 
# This version works with the combined data. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('tidyverse', 'dtw', 'parallel')
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
load(path_dtw_m_list)

# Plot traces on spectrogram (optional)
if(F){
  pdf(path_pdf_test_traces)
  for(i in 1:nrow(st)){
    start = st$Begin.Time..s.[i] - 0.05
    end = st$End.Time..s.[i] + 0.05
    path_audio = ifelse(str_detect(st$fs[i], '2020'), path_audio_20, path_audio_21)
    wave = load.wave(path_audio_file = paste0(path_audio, '/', st$file[i], '.wav'), 
                     from = start,
                     to = end)
    better.spectro(wave, main = st$fs[i], ylim = c(0, 6000), ovl = 400)
    trace = smooth_traces[[i]]
    lines(seq(0.05, end-start-0.05, length.out = length(trace)), trace, lwd = 3, col = alpha(3, 0.5))
    abline(v = c(0.05, end-start-0.05), lty = 2, lwd = 3, col = alpha(1, 0.5))
  }
  dev.off()
}

# Plot most extreme case per call type
pdf(path_pdf_test_dtw)
for(type in names(m_list)){
  m = m_list[[type]]
  rs = rowSums(m)
  the_ones = rownames(m)[order(rs, decreasing = T)][1:10]
  for(one in the_ones){
    i = which(st$fs == one)
    start = st$Begin.Time..s.[i] - 0.05
    end = st$End.Time..s.[i] + 0.05
    path_audio = ifelse(str_detect(st$fs[i], '2020'), path_audio_20, path_audio_21)
    wave = load.wave(path_audio_file = paste0(path_audio, '/', st$file[i], '.wav'), 
                     from = start,
                     to = end)
    better.spectro(wave, main = paste(type, st$fs[i]), ylim = c(0, 6000), ovl = 400)
    trace = smooth_traces[[i]]
    lines(seq(0.05, end-start-0.05, length.out = length(trace)), trace, lwd = 3, col = alpha(3, 0.5))
    abline(v = c(0.05, end-start-0.05), lty = 2, lwd = 3, col = alpha(1, 0.5))
  }
}
dev.off()

# Run tests
message('Running tests...')
if(length(smooth_traces) != length(waves)) stop('Waves and traces do not match!')
if(all(names(smooth_traces) != names(waves))) stop('Names waves and traces do not match!')

# Report success if nothing breaks
message('No problems to report. All fine.')
