# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 16-10-2021
# Date last modified: 03-02-2022
# Author: Simeon Q. Smeele
# Description: Prepare data for the date models.
# NOTE: subsetting for now and removing kaws. 
# source('ANALYSIS/CODE/02_time_effect/01_prepare_data_dates.R')
# This version is updated for the 2021 data and the new data structure. 
# This version moves some code out into a function. 
# This version is updated for the renamed objects (partially).
# This version also includes the 2020 data. 
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
n_sub = 300

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Functions
prep.dat = function(m, st){
  n = rownames(m)
  print(length(n))
  if(length(n) > n_sub) subber = sample(length(n), n_sub) else subber = 1:length(n)
  inds = as.integer(as.factor(st[n,]$bird[subber]))
  recs = as.integer(as.factor(paste(st[n,]$bird[subber], st[n,]$file[subber])))
  dates = st[n,]$file %>% str_sub(1, 10) %>% str_replace_all('_', '-') %>% as.Date %>% as.numeric
  clean_dat = m.to.df(m[subber, subber], inds, recs, day_saver = dates, clean_data = T)
  sub_dat = prep.dat.dates(clean_dat, plot_it = F)
  sub_dat$settings = NULL
  return(sub_dat)
}

run.all.prep = function(path, st, year){
  print(path)
  load(path)
  m_list = get(sprintf('m_list_%s', year))
  m_list$kaw = NULL
  m_list$contact_mix = NULL
  m_list$frill = NULL
  out = lapply(m_list, prep.dat, st)
  names(out) = names(m_list)
  return(out)
}

# Clean up data
data_sets_date_20 = lapply(c(path_dtw_m_list, path_mfcc_m_list, path_spcc_m_list, path_specan_m_list), 
                           run.all.prep, st_20, 20)
names(data_sets_date_20) = c('dtw', 'mfcc', 'spcc', 'specan')
data_sets_date_21 = lapply(c(path_dtw_m_list, path_mfcc_m_list, path_spcc_m_list, path_specan_m_list), 
                        run.all.prep, st_21, 21)
names(data_sets_date_21) = c('dtw', 'mfcc', 'spcc', 'specan')

# Save
save(data_sets_date_20, data_sets_date_21, file = path_data_sets_date)
message('Saved all datasets.')
