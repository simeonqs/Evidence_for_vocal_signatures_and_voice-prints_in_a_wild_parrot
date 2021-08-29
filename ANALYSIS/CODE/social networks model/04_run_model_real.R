# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: chapter II
# Date started: 24-08-2021
# Date last modified: 27-08-2021
# Author: Simeon Q. Smeele
# Description: Running model on real data.  
# This version was moved to the new repo and paths are fixed. 
# source('ANALYSIS/CODE/luscinia/social networks model/04_run_model_real.R')
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
path_data = 'ANALYSIS/RESULTS/luscinia/social networks model/real_dat.RData'
path_model = 'ANALYSIS/CODE/luscinia/social networks model/m_3.stan'
path_out = 'ANALYSIS/RESULTS/luscinia/social networks model/real_model.RData'

# Load data
load(path_data)

# Print
cat('Starting model with', clean_dat$N_obs, 'observations. \n')

# Run model
model = stan(path_model,
             data = clean_dat, 
             chains = 4, cores = 4,
             iter = 2000, warmup = 500,
             control = list(max_treedepth = 15, adapt_delta = 0.95))

# Save
save('model', file = path_out)

# Print the results
cat('Here are the results: \n')
print(precis(model, depth = 1))

