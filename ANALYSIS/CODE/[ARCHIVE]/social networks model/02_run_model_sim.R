# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: chapter II
# Date started: 24-08-2021
# Date last modified: 20-01-2022
# Author: Simeon Q. Smeele
# Description: Running model on simulated data.  
# This version was moved to the new repo and paths were fixed. 
# This version has fixed paths for the new location. 
# This version used cmdstanr. 
# source('ANALYSIS/CODE/social networks model/02_run_model_sim.R')
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('rethinking', 'tidyverse', 'cmdstanr')
for(i in libraries){
  if(! i %in% installed.packages()) lapply(i, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Clear R
rm(list = ls())

# Paths
path_data = 'ANALYSIS/RESULTS/social networks model/sim_dat.RData'
path_model = 'ANALYSIS/CODE/social networks model/m_10.stan'
path_out = 'ANALYSIS/RESULTS/social networks model/sim_model.RData'

# Load data
load(path_data)

# Print
cat('Starting model with', clean_dat$N_obs, 'observations. \n')

# Run model
model = cmdstan_model(path_model)
fit = model$sample(data = clean_dat, 
                   seed = 1, 
                   chains = 4, 
                   parallel_chains = 4,
                   refresh = 100)

draws = fit$draws()
draws_flat = apply(draws, 3, rbind)
# colnames(draws_flat)
dens(draws_flat[,'b_bar_ind'])
dens(draws_flat[,'b_bar_rec'])
dens(draws_flat[,'sigma_call'])

# Save
save('fit', file = path_out)