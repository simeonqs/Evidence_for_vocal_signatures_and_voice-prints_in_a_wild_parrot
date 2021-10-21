# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 18-10-2021
# Date last modified: 20-10-2021
# Author: Simeon Q. Smeele
# Description: Compare distance measured by different methods. 
# This version works with the combined datasets. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('rethinking', 'warbleR', 'MASS', 'tidyverse', 'readxl', 'umap', 'ape')
for(lib in libraries){
  if(! lib %in% installed.packages()) lapply(lib, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Clean R
rm(list=ls()) 

# Paths
path_functions = 'ANALYSIS/CODE/functions'
path_mfcc = 'ANALYSIS/RESULTS/00_run_methods/mfcc/results.RData'
path_specan = 'ANALYSIS/RESULTS/00_run_methods/specan/results.RData'
path_spcc = 'ANALYSIS/RESULTS/00_run_methods/spcc/results.RData'
path_pdf = 'ANALYSIS/RESULTS/01_compare_methods/results.pdf'

# Load data
load(path_mfcc)
load(path_spcc)
load(path_specan)

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Functions
prep.dat = function(data_set, m_dist, N_obs = 100){
  set.seed(1)
  if(nrow(data_set) > N_obs) subber = sample(nrow(data_set), N_obs) else subber = sample(nrow(data_set))
  inds = as.integer(as.factor(data_set$bird[subber]))
  recs = as.integer(as.factor(data_set$file[subber]))
  clean_dat = m.to.df(m_dist[subber, subber], inds, recs, clean_data = T)
  return(clean_dat)
}

# Clean up data
mfcc_clean_dats = lapply(1:length(data_sets), function(i) prep.dat(data_sets[[i]], mfcc_dists[[i]]))
names(mfcc_clean_dats) = names(data_sets)
specan_clean_dats =  lapply(1:length(data_sets), function(i) prep.dat(data_sets[[i]], specan_dists[[i]]))
names(specan_clean_dats) = names(data_sets)
### NOTE THAT THIS IS A TEMP FIX
spcc_clean_dats =  lapply(1:12, function(i) prep.dat(data_sets[[i]], spcc_dists[[i]]))
names(spcc_clean_dats) = names(data_sets)[-13]

# Plot correlations
pdf(path_pdf, 10, 10)
par(mfrow = c(4, 4))
for(i in 1:length(data_sets)){
  dat_mfcc = mfcc_clean_dats[[i]]
  dat_specan = specan_clean_dats[[i]]
  plot(dat_mfcc$d, dat_specan$d, pch = 16, col = alpha(1, 0.3), 
       xlab = 'MFCC', ylab = 'SPECAN', main = str_replace(names(data_sets)[i], '_', ' '))
}
par(mfrow = c(4, 4))
### NOTE THAT THIS IS A TEMP FIX
for(i in 1:12){
  dat_spcc = spcc_clean_dats[[i]]
  dat_specan = specan_clean_dats[[i]]
  plot(dat_spcc$d, dat_specan$d, pch = 16, col = alpha(1, 0.3), 
       xlab = 'SPCC', ylab = 'SPECAN', main = str_replace(names(data_sets)[i], '_', ' '))
}
par(mfrow = c(4, 4))
### NOTE THAT THIS IS A TEMP FIX
for(i in 1:12){
  dat_mfcc = mfcc_clean_dats[[i]]
  dat_spcc = spcc_clean_dats[[i]]
  plot(dat_mfcc$d, dat_spcc$d, pch = 16, col = alpha(1, 0.3), 
       xlab = 'MFCC', ylab = 'SPCC', main = str_replace(names(data_sets)[i], '_', ' '))
}
dev.off()

