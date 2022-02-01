# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 30-01-2022
# Date last modified: 30-10-2021
# Author: Simeon Q. Smeele
# Description: Prepare data for the year models. 
# NOTE: subsetting for now. 
# source('ANALYSIS/CODE/03_year_effect/00_prepare_data_year.R')
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
load(path_dtw_year)
st_20$`complete sequence` = NA
st_20$notes = NA
st_21$notes.x = NA
st_21$notes.y = NA
st_21$...8 = NA
st = rbind(st_20, st_21)

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
  years = st[n,]$file %>% str_sub(1, 4) %>% as.numeric
  clean_dat = m.to.df(m[subber, subber], inds, recs, year_saver = years, clean_data = T)
  sub_dat = prep.dat.year(clean_dat, plot_it = T)
  sub_dat$settings = NULL
  return(sub_dat)
}

# run.all.prep = function(path, st){
#   print(path)
#   load(path)
#   out = lapply(m_list, prep.dat, st)
#   names(out) = names(m_list)
#   return(out)
# }

# Clean up data
# data_sets_year = lapply(c(path_dtw_m_list, path_mfcc_m_list, path_spcc_m_list, path_specan_m_list), 
#                            run.all.prep, st)
# names(data_sets_year) = c('dtw', 'mfcc', 'spcc', 'specan')

# Run for just contact calls
data_sets_year = prep.dat(m, st)

# Save
save(data_sets_year, file = path_data_sets_year)
message('Saved all datasets.')
