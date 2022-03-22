# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 21-03-2022
# Date last modified: 21-03-2022
# Author: Simeon Q. Smeele
# Description: Simple simulation of data that we might get from dtw including time. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('data.table', 'tidyverse', 'rethinking')
for(lib in libraries){
  if(! lib %in% installed.packages()) lapply(lib, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Settings
set.seed(6)
settings = list(N_ind = 3,
                N_var = 2,
                lambda_obs = 10,
                lambda_rec = 1,
                sigma_ind = 0.5,
                sigma_rec = 0.3,
                sigma_obs = 0.05,
                slope_time = 0.02,
                slope_day = 0.00,
                dur_rec = 20,
                dur_dates = 20)

# Paths
path_functions = 'ANALYSIS/CODE/functions'
path_out = 'ANALYSIS/RESULTS/vectorised srm/sim_dat_time.RData'

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Simulate
clean_dat = sim.vsrm.data.time(settings, plot_it = T)
plot(clean_dat$time_diff_log[clean_dat$rec < 4], clean_dat$acc_dist[clean_dat$rec < 4], 
     col = clean_dat$rec[clean_dat$rec < 4])

# Save
save(clean_dat, file = path_out)

# Report
message(sprintf('Simulated %s calls. Saved a total of %s data points',
                clean_dat$N_call, clean_dat$N_obs))