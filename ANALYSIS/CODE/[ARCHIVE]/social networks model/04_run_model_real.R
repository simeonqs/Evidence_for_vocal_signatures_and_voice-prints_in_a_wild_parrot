# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: chapter II
# Date started: 24-08-2021
# Date last modified: 24-09-2021
# Author: Simeon Q. Smeele
# Description: Running model on real data.  
# This version was moved to the new repo and paths are fixed. 
# source('ANALYSIS/CODE/social networks model/04_run_model_real.R')
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
path_data = 'ANALYSIS/RESULTS/social networks model/real_dat.RData'
path_model_10 = 'ANALYSIS/CODE/social networks model/m_10.stan'
path_model_13 = 'ANALYSIS/CODE/social networks model/m_13.stan'
path_model_14 = 'ANALYSIS/CODE/social networks model/m_14.stan'
path_out = 'ANALYSIS/RESULTS/social networks model/real_model.RData'
path_out_time = 'ANALYSIS/RESULTS/social networks model/real_model_time.RData'
path_out_all = 'ANALYSIS/RESULTS/social networks model/real_model_all.RData'

# Load data
load(path_data)

# Print
message(sprintf('Starting models with %s observations.', clean_dat$N_obs))

# Run models
model = stan(path_model_10,
             data = clean_dat,
             chains = 4, cores = 4,
             iter = 2000, warmup = 500,
             control = list(max_treedepth = 15, adapt_delta = 0.95))
save('model', file = path_out)

model = stan(path_model_13,
             data = clean_dat,
             chains = 4, cores = 4,
             iter = 2000, warmup = 500,
             control = list(max_treedepth = 15, adapt_delta = 0.95))
save('model', file = path_out_time)

model = stan(path_model_14,
             data = clean_dat, 
             chains = 4, cores = 4,
             iter = 2000, warmup = 500,
             control = list(max_treedepth = 15, adapt_delta = 0.95))
save('model', file = path_out_all)

# Print the results
message('Here are the results of the time model: \n')
print(precis(model, depth = 1))