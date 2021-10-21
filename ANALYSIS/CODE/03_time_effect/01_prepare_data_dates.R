# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 16-10-2021
# Date last modified: 21-10-2021
# Author: Simeon Q. Smeele
# Description: Prepare data for the date models.
# NOTE: subsetting for now. 
# This version moves some code out into a function. 
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
path_out = 'ANALYSIS/RESULTS/01_time_effect/data_sets_dates.RData'

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Functions
prep.dat = function(file){
  print(file)
  load(file)
  if(nrow(d_sub) > 100) subber = sample(nrow(d_sub), 100) else subber = sample(nrow(d_sub))
  inds = as.integer(as.factor(d_sub$ind[subber]))
  recs = as.integer(as.factor(d_sub$file[subber]))
  dates = d_sub$file %>% str_sub(1, 10) %>% str_replace_all('_', '-') %>% as.Date %>% as.numeric
  clean_dat = m.to.df(m_sub[subber, subber], inds, recs, day_saver = dates, clean_data = T)
  sub_dat = prep.dat.dates(clean_dat, plot_it = T)
  return(sub_dat)
}

# Clean up data
files_mfcc = list.files(path_mfcc, full.names = T)
files_spcc = list.files(path_spcc, full.names = T)
data_sets_mfcc_dates = files_mfcc %>% lapply(prep.dat)
names(data_sets_mfcc_dates) = files_mfcc
data_sets_spcc_dates = files_spcc %>% lapply(prep.dat)
names(data_sets_spcc_dates) = files_spcc

# Save
save(data_sets_mfcc_dates, data_sets_spcc_dates, file = path_out)
message('Saved both datasets.')
