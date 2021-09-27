# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: chapter II
# Date started: 24-08-2021
# Date last modified: 24-09-2021
# Author: Simeon Q. Smeele
# Description: Simple simulation of data that we might get from dtw including time. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('data.table', 'tidyverse', 'rethinking')
for(i in libraries){
  if(! i %in% installed.packages()) lapply(i, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Settings
set.seed(2)
settings = list(N_ind = 4,
                N_var = 2,
                lambda_obs = 4,
                lambda_rec = 4,
                sigma_ind = 1,
                sigma_rec = 0.1,
                sigma_obs = 0.01,
                slope_time = 0.02,
                dur_rec = 20)

# Paths
path_functions = 'ANALYSIS/CODE/functions'
path_out = 'ANALYSIS/RESULTS/social networks model/sim_dat_time.RData'

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Simulate
clean_dat = sim.sn.data.time(settings, plot_it = T)
clean_dat$time = clean_dat$time/60

# Save
save(clean_dat, file = path_out)

# Report
message(sprintf('Simulated %s calls. Saved a total of %s data points',
                clean_dat$N_call, clean_dat$N_obs))