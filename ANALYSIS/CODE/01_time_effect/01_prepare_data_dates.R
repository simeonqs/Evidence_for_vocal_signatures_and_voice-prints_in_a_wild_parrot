# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 16-10-2021
# Date last modified: 17-10-2021
# Author: Simeon Q. Smeele
# Description: Prepare data for the date models.
# NOTE: subsetting for now. 
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
  if(nrow(d_sub) > 200) subber = sample(nrow(d_sub), 200) else subber = sample(nrow(d_sub))
  inds = as.integer(as.factor(d_sub$ind[subber]))
  recs = as.integer(as.factor(d_sub$file[subber]))
  dates = d_sub$files %>% str_sub(1, 10) %>% str_replace_all('_', '-') %>% as.Date %>% as.numeric
  if(length(time_saver) == 0) time_saver = d_sub$time[subber]/60/60
  clean_dat = m.to.df(m_sub[subber, subber], inds, recs, date_saver = dates, clean_data = T)
  subber = which(clean_dat$same_rec[clean_dat$rec_pair] == 1)
  if(any(clean_dat$ind_i[subber] != clean_dat$ind_j[subber])) stop('Problem subsetting!')
  sub_dat = list(call_i = clean_dat$call_i[subber] %>% as.factor %>% as.integer,
                 call_j = clean_dat$call_j[subber] %>% as.factor %>% as.integer,
                 rec_pair = clean_dat$rec_pair[subber] %>% as.factor %>% as.integer,
                 ind = clean_dat$ind_i[subber] %>% as.factor %>% as.integer,
                 time = clean_dat$date[subber],
                 d = clean_dat$d[subber] %>% scale %>% as.numeric,
                 N_obs = length(subber),
                 N_call = length(unique(c(clean_dat$call_i[subber],
                                          clean_dat$call_j[subber]))),
                 N_rec_pair = length(unique(clean_dat$rec_pair[subber])),
                 N_ind = length(unique(clean_dat$ind_i[subber])),
                 settings = clean_dat$settings)
  sub_dat$date_per_rec = sapply(seq_along(unique(sub_dat$rec_pair)), 
                                function(x) sub_dat$date[sub_dat$rec_pair == x][1])
  sub_dat$ind_per_rec = sapply(seq_along(unique(sub_dat$rec_pair)), 
                               function(x) sub_dat$ind[sub_dat$rec_pair == x][1])
  plot(sub_dat$date, sub_dat$d, col = sub_dat$ind, pch = 16)
  return(sub_dat)
}

# Clean up data
files_mfcc = list.files(path_mfcc, full.names = T)
files_spcc = list.files(path_spcc, full.names = T)
data_sets_mfcc = files_mfcc %>% lapply(prep.dat)
names(data_sets_mfcc) = files_mfcc
data_sets_spcc = files_spcc %>% lapply(prep.dat)
names(data_sets_spcc) = files_spcc

# Save
save(data_sets_mfcc, data_sets_spcc, file = path_out)
message('Saved both datasets.')