# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 13-10-2021
# Date last modified: 21-01-2022
# Author: Simeon Q. Smeele
# Description: Prepare data for the time and date models.
# This version is updated for the 2021 data and the new data structure. 
# NOTE: subsetting for now and removing kaws. 
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

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Load data
load(path_data)

# Functions
prep.dat = function(m){
  
  n = rownames(m)
  if(length(n) > 300) subber = sample(length(n), 300) else subber = 1:length(n)
  inds = as.integer(as.factor(st[n,]$bird[subber]))
  recs = as.integer(as.factor(paste(st[n,]$bird[subber], st[n,]$file[subber])))
  
  time_saver = st[n,]$Begin.Time..s.[subber]/60/60
  # if(length(time_saver) == 0) time_saver = d_sub$time[subber]/60/60
  
  clean_dat = m.to.df(m[subber, subber], inds, recs, time_saver = time_saver, clean_data = T)
  
  subber = which(clean_dat$same_rec[clean_dat$rec_pair] == 1)
  if(any(clean_dat$ind_i[subber] != clean_dat$ind_j[subber])) stop('Problem subsetting!')
  sub_dat = list(call_i = clean_dat$call_i[subber] %>% as.factor %>% as.integer,
                 call_j = clean_dat$call_j[subber] %>% as.factor %>% as.integer,
                 rec = clean_dat$rec_i[subber] %>% as.factor %>% as.integer,
                 ind = clean_dat$ind_i[subber] %>% as.factor %>% as.integer,
                 time = clean_dat$time[subber],
                 d = clean_dat$d[subber] %>% scale %>% as.numeric,
                 N_obs = length(subber),
                 N_call = length(unique(c(clean_dat$call_i[subber],
                                          clean_dat$call_j[subber]))),
                 N_rec = length(unique(clean_dat$rec_i[subber])),
                 N_ind = length(unique(clean_dat$ind_i[subber])),
                 settings = clean_dat$settings)
  # plot(sub_dat$time, sub_dat$d, col = sub_dat$ind, pch = 16)
  return(sub_dat)
}
run.all.prep = function(path){
  load(path)
  m_list$kaw = NULL
  out = lapply(m_list, prep.dat)
  names(out) = names(m_list)
  return(out)
}

# Clean up data
data_sets_time = lapply(c(path_dtw_m_list, path_mfcc_m_list, path_spcc_m_list, path_specan_m_list), 
                       run.all.prep)
names(data_sets_time) = c('dtw', 'mfcc', 'spcc', 'specan')

# Save
save(data_sets_time, file = path_data_sets_time)
message('Saved all datasets.')
