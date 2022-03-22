# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 21-03-2022
# Date last modified: 21-03-2022
# Author: Simeon Q. Smeele
# Description: Simple simulation of data that we might get from dtw including dates.
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('tidyverse', 'rethinking')
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
path_out = 'ANALYSIS/RESULTS/vectorised srm/sim_dat_date.RData'

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Simulate
clean_dat = sim.vsrm.data.dates(settings, plot_it = T)
plot(clean_dat$month_diff[clean_dat$ind < 4], clean_dat$acc_dist[clean_dat$ind < 4], 
     col = clean_dat$ind[clean_dat$ind < 4])

# Save
save(clean_dat, file = path_out)

# Report
message(sprintf('Simulated %s calls. Saved a total of %s data points',
                clean_dat$N_call, clean_dat$N_obs))