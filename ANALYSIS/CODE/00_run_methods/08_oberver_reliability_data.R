# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 03-08-2023
# Date last modified: 03-08-2023
# Author: Simeon Q. Smeele
# Description: Making a subset for the second observer. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('callsync', 'tidyverse')
for(lib in libraries){
  if(! lib %in% installed.packages()) lapply(lib, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Clean R
rm(list=ls()) 
set.seed(1)

# Paths
source('ANALYSIS/CODE/paths.R')

# Load data
load(path_data)
load(path_waves)

# Set random seed
set.seed(1)

# Subset 200 calls for observer reliability
random_200 = sample(st$fs, 200)

# Create folder and plot spectrograms
path_random_out = sprintf('%s/random_calls', path_observer_reliability)
if(!dir.exists(path_random_out)) dir.create(path_random_out)
for(i in seq_along(random_200)){
  pdf(sprintf('%s/%s.pdf', path_random_out, i))
  better.spectro(waves[[random_200[i]]], xlim = c(0, 0.2), ylim = c(0, 15000))
  dev.off()
}  

# Save pdf
write.csv2(random_200, sprintf('%s/random_calls.csv', path_observer_reliability))

# Create PDF with examples
path_pdf_out = sprintf('%s/examples.pdf', path_observer_reliability)
pdf(path_pdf_out, 20, 5)
par(mfrow = c(3, 11))
for(i in seq_len(3)){
  for(ct in names(data_sets)[-12]){ 
    random_call = sample(data_sets[[ct]][!data_sets[[ct]] %in% random_200], 1)
    better.spectro(waves[[random_call]], xlim = c(0, 0.2), ylim = c(0, 15000))
    if(i == 1) mtext(ct)
  }
}  
dev.off()

# Create empty folders
dir = sprintf('%s/sorted_calls', path_observer_reliability)
if(!dir.exists(dir)) dir.create(dir)
for(ct in names(data_sets)[-12]){
  dir = sprintf('%s/sorted_calls/%s', path_observer_reliability, ct)
  if(!dir.exists(dir)) dir.create(dir)
}
