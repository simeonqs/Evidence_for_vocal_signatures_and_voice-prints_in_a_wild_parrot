# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 18-10-2021
# Date last modified: 18-10-2021
# Author: Simeon Q. Smeele
# Description: Compare distance measured by different methods. 
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
path_mfcc = 'ANALYSIS/RESULTS/mfcc/datasets per call type'
path_spcc = 'ANALYSIS/RESULTS/spcc/datasets per call type'

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Functions
prep.dat = function(file){
  set.seed(1)
  print(file)
  load(file)
  if(nrow(d_sub) > 100) subber = sample(nrow(d_sub), 100) else subber = sample(nrow(d_sub))
  inds = as.integer(as.factor(d_sub$ind[subber]))
  recs = as.integer(as.factor(d_sub$file[subber]))
  clean_dat = m.to.df(m_sub[subber, subber], inds, recs)
  return(clean_dat)
}

# Clean up data
files_mfcc = list.files(path_mfcc, full.names = T)
files_spcc = list.files(path_spcc, full.names = T)
data_sets_mfcc = files_mfcc %>% lapply(prep.dat)
names(data_sets_mfcc) = files_mfcc
data_sets_spcc = files_spcc %>% lapply(prep.dat)
names(data_sets_spcc) = files_spcc

# Plot correlations
i = 3
dat_mfcc = data_sets_mfcc[[i]]
dat_spcc = data_sets_spcc[[i]]
plot(dat_mfcc$d, dat_spcc$d)


