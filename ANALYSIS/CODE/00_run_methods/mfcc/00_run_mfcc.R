# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 22-09-2021
# Date last modified: 20-10-2021
# Author: Simeon Q. Smeele
# Description: Running mfcc per call type and saving data as long distance for SN model. 
# This version saves objects together. 
# source('ANALYSIS/CODE/00_run_methods/mfcc/00_run_mfcc.R')
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# DATA ----
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('data.table', 'tidyverse', 'warbleR')
for(i in libraries){
  if(! i %in% installed.packages()) lapply(i, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Clean R
rm(list=ls()) 

# Paths
path_functions = 'ANALYSIS/CODE/functions'
path_audio = 'ANALYSIS/DATA/audio'
path_out = 'ANALYSIS/RESULTS/00_run_methods/mfcc/results.RData'
path_data_sets = 'ANALYSIS/RESULTS/00_run_methods/data_sets.RData'

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Audio files 
audio_files = list.files(path_audio,  '*wav', full.names = T)

# Load data
load(path_data_sets)

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# ANALYSIS: all calls ----
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Get better start and end times - keep times isolated contact calls
data_sets_updated = lapply(data_sets[-length(data_sets)], wave.detec, path_audio, bp = 0.3)
data_sets_updated = append(data_sets_updated, data_sets[length(data_sets)])
names(data_sets_updated) = names(data_sets)

# Test how well it worked
## not working well for growly calls and combined calls
if(F){
  pdf('~/Desktop/test.pdf')
  set.seed(1)
  for(nr in 1:length(data_sets_updated)){
    for(i in sample(seq_along(data_sets_updated[[nr]]), 10)){
      wave = readWave(paste0(path_audio, '/', data_sets_updated[[nr]]$file[i], '.wav'), 
                      from = data_sets_updated[[nr]]$Begin.Time..s.[i] - 0.1, 
                      to = data_sets_updated[[nr]]$End.Time..s.[i] + 0.1, 
                      units = 'seconds')
      better.spectro(wave)
      abline(v = 0.1, lty = 2, lwd = 3)
      abline(v = length(wave@left)/wave@samp.rate - 0.1, lty = 2, lwd = 3)
    }
  }
  dev.off()
}

# Functions to run mfcc
run.mfcc = function(path_audio_file, 
                    from,
                    to){
  wave = load.wave(path_audio_file, 
                   from,
                   to)
  melfcc_out = suppressWarnings(
    melfcc(wave, wintime = 512/44100, hoptime = 50/44100, numcep = 20, minfreq = 300)
  )
  means = melfcc_out %>% apply(2, mean)
  sds = melfcc_out %>% apply(2, sd)
  out = as.data.frame(t(means))
  names(out) = paste('V', names(out))
  return(cbind(out, as.data.frame(t(sds))))
}

run.mfcc.multiple = function(data_set){
  out = lapply(1:nrow(data_set), function(i) run.mfcc(paste0(path_audio, '/', data_set$file[i], '.wav'), 
                                                      data_set$Begin.Time..s.[i], 
                                                      data_set$End.Time..s.[i]))
  return(bind_rows(out))
}


# Run mfcc
mfcc_out = lapply(data_sets_updated, run.mfcc.multiple)

# Calculate distance matrices
## make sure this dist is correct - move function out and write unit tests
mfcc_dists = lapply(mfcc_out, function(x) as.matrix(dist(scale(x[,-1]))))

# Save
save(mfcc_out, mfcc_dists, data_sets, file = path_out)
message('Done.')