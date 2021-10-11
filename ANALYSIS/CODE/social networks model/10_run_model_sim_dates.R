# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: chapter II
# Date started: 24-08-2021
# Date last modified: 08-10-2021
# Author: Simeon Q. Smeele
# Description: Running model on simulated data.  
# This version was moved to the new repo and paths were fixed. 
# This version has fixed paths for the new location. 
# This version runs on the data with time. 
# This version runs with the new date model. 
# source('ANALYSIS/CODE/social networks model/10_run_model_sim_dates.R')
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
path_data = 'ANALYSIS/RESULTS/social networks model/sim_dat_date.RData'
path_model = 'ANALYSIS/CODE/social networks model/m_date_1.stan'
path_out = 'ANALYSIS/RESULTS/social networks model/sim_model_date.RData'

# Load data
load(path_data)

# Print
message('Starting model with ', sub_dat$N_obs, ' observations.')

# Run model
model = stan(path_model,
             data = sub_dat, 
             chains = 1, cores = 1,
             iter = 2000, warmup = 500,
             control = list(max_treedepth = 15, adapt_delta = 0.95))

# Save
save('model', file = path_out)

# Print the results
message('Here are the results: \n')
print(precis(model, depth = 1))