# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: chapter II
# Date started: 27-08-2021
# Date last modified: 21-10-2021
# Author: Simeon Q. Smeele
# Description: Simple simulation of data that we might get from dtw including dates 
# This version moves some code out into a function. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('data.table', 'tidyverse', 'rethinking')
for(i in libraries){
  if(! i %in% installed.packages()) lapply(i, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Settings
set.seed(1)
settings = list(N_ind = 5,
                N_var = 2,
                lambda_obs = 4,
                lambda_rec = 5,
                sigma_ind = 1,
                sigma_rec = 0.2,
                sigma_obs = 0.1,
                slope_time = 0.00,
                slope_day = 0.05,
                dur_rec = 20,
                dur_dates = 20)

# Paths
path_functions = 'ANALYSIS/CODE/functions'
path_out = 'ANALYSIS/RESULTS/social networks model/sim_dat_date.RData'

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Simulate
clean_dat = sim.sn.data.time(settings, plot_it = T)
clean_dat$date = clean_dat$date

# Subset data
subber = which(clean_dat$same_ind[clean_dat$ind_pair] == 1)
if(any(clean_dat$ind_i[subber] != clean_dat$ind_j[subber])) stop('Problem subsetting!')
sub_dat = prep.dat.dates(clean_dat, plot_it = T)

# Save
save(sub_dat, file = path_out)

# Print str
str(sub_dat)

# Report
message(sprintf('Simulated %s calls. Saved a total of %s data points',
                sub_dat$N_call, sub_dat$N_obs))