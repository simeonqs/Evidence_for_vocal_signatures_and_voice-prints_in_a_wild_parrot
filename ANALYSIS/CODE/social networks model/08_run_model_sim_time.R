# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: chapter II
# Date started: 24-08-2021
# Date last modified: 30-09-2021
# Author: Simeon Q. Smeele
# Description: Running model on simulated data.  
# This version was moved to the new repo and paths were fixed. 
# This version has fixed paths for the new location. 
# This version runs on the data with time. 
# This version switches to a model that subsets the data to same ind and rec first. 
# source('ANALYSIS/CODE/social networks model/08_run_model_sim_time.R')
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('rethinking', 'tidyverse')
for(i in libraries){
  if(! i %in% installed.packages()) lapply(i, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Clear R
rm(list = ls())

# Paths
path_data = 'ANALYSIS/RESULTS/social networks model/sim_dat_time.RData'
path_model = 'ANALYSIS/CODE/social networks model/m_time_2.stan'
path_out = 'ANALYSIS/RESULTS/social networks model/sim_model_time.RData'

# Load data
load(path_data)

# Print
message('Starting model with ', clean_dat$N_obs, ' observations.')

# Subset data
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
plot(sub_dat$time, sub_dat$d, col = sub_dat$ind, pch = sub_dat$rec)

# Run model
model = stan(path_model,
             data = sub_dat, 
             chains = 4, cores = 4,
             iter = 2000, warmup = 500,
             control = list(max_treedepth = 15, adapt_delta = 0.95))

# Save
save(model, sub_dat, file = path_out)

# Print the results
message('Here are the results: \n')
print(precis(model, depth = 1))