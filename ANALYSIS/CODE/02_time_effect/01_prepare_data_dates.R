# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 16-10-2021
# Date last modified: 09-03-2022
# Author: Simeon Q. Smeele
# Description: Prepare data for the date models.
# NOTE: subsetting for now and removing kaws. 
# source('ANALYSIS/CODE/02_time_effect/01_prepare_data_dates.R')
# This version is updated for the 2021 data and the new data structure. 
# This version moves some code out into a function. 
# This version is updated for the renamed objects (partially).
# This version also includes the 2020 data. 
# This version runs on combined data. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('tidyverse')
for(lib in libraries){
  if(! lib %in% installed.packages()) lapply(lib, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Clean R
rm(list=ls()) 

# Paths
source('ANALYSIS/CODE/paths.R')

# Load data
load(path_data)

# Settings
n_sub = 1000

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Functions
prep.dat = function(m, st){
  n = rownames(m)
  print(length(n))
  if(length(n) > n_sub) subber = sample(length(n), n_sub) else subber = 1:length(n)
  inds = as.integer(as.factor(st[n,]$bird[subber]))
  recs = as.integer(as.factor(paste(st[n,]$bird[subber], st[n,]$file[subber])))
  day_saver = st[n,]$file %>% str_sub(1, 10) %>% str_replace_all('_', '-') %>% as.Date %>% as.numeric
  clean_dat = m.to.df(m[subber, subber], inds, recs, day_saver = day_saver, clean_data = T)
  sub_dat = prep.dat.dates(clean_dat, plot_it = F)
  return(sub_dat)
}

run.all.prep = function(path, st){
  print(path)
  load(path)
  out = lapply(m_list, prep.dat, st)
  names(out) = names(m_list)
  return(out)
}

# Clean up data
data_sets_date = lapply(c(path_dtw_m_list, path_mfcc_m_list, path_spcc_m_list, path_specan_m_list), 
                           run.all.prep, st)
names(data_sets_date) = c('dtw', 'mfcc', 'spcc', 'specan')

# Save
save(data_sets_date, file = path_data_sets_date)
message('Saved all datasets.')
