# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: chapter II
# Date started: 24-08-2021
# Date last modified: 08-09-2021
# Author: Simeon Q. Smeele
# Description: Simple simulation of data that we might get from dtw. 
# This version adds data to code whether or not an ind pair is the same ind. 
# This version adds the rec level. 
# This version was moved to the new repo and paths were fixed. 
# This version was moved to own location, paths were fixed and simulation moved to function. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('data.table', 'tidyverse', 'rethinking')
for(i in libraries){
  if(! i %in% installed.packages()) lapply(i, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Settings
set.seed(2)
settings = list(N_ind = 7,
                N_var = 2,
                lambda_rec = 5,
                lambda_obs = 3,
                sigma_ind = 0.001,
                sigma_rec = 1,
                sigma_obs = 0.1)

# Paths
path_functions = 'ANALYSIS/CODE/functions'
path_out = 'ANALYSIS/RESULTS/social networks model/sim_dat.RData'

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Simulate
clean_dat = sim.sn.data(settings, plot_it = T)

# Save
save(clean_dat, file = path_out)

# Report
message(sprintf('Simulated %s calls. Saved a total of %s data points',
                clean_dat$N_calls, clean_dat$N_obs))