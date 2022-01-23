# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 16-10-2021
# Date last modified: 21-10-2021
# Author: Simeon Q. Smeele
# Description: Prepare data for the date models.
# This version is updated for the 2021 data and the new data structure. 
# NOTE: subsetting for now and removing kaws. 
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
source('ANALYSIS/CODE/paths.R')

# Load data
load(path_data)

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Functions
prep.dat = function(m){
  n = rownames(m)
  if(length(n) > 300) subber = sample(length(n), 300) else subber = 1:length(n)
  inds = as.integer(as.factor(st[n,]$bird[subber]))
  recs = as.integer(as.factor(paste(st[n,]$bird[subber], st[n,]$file[subber])))
  dates = st[n,]$file %>% str_sub(1, 10) %>% str_replace_all('_', '-') %>% as.Date %>% as.numeric
  clean_dat = m.to.df(m[subber, subber], inds, recs, day_saver = dates, clean_data = T)
  sub_dat = prep.dat.dates(clean_dat, plot_it = F)
  sub_dat$settings = NULL
  return(sub_dat)
}

run.all.prep = function(path){
  load(path)
  m_list$kaw = NULL
  m_list$contact_mix = NULL
  out = lapply(m_list, prep.dat)
  names(out) = names(m_list)
  return(out)
}

# Clean up data
data_sets_date = lapply(c(path_dtw_m_list, path_mfcc_m_list, path_spcc_m_list, path_specan_m_list), 
                        run.all.prep)
names(data_sets_date) = c('dtw', 'mfcc', 'spcc', 'specan')

# Save
save(data_sets_date, file = path_data_sets_date)
message('Saved all datasets.')
