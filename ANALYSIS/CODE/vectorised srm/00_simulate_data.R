# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 15-03-2022
# Date last modified: 21-03-2022
# Author: Simeon Q. Smeele
# Description: Simple simulation of data that we might get from dtw. Data is stored in matrices.
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('tidyverse', 'rethinking')
for(lib in libraries){
  if(! lib %in% installed.packages()) lapply(lib, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Settings
set.seed(4)
settings = list(N_ind = 3,
                N_var = 5,
                lambda_rec = 2,
                lambda_obs = 2,
                sigma_ind = 0.3,
                sigma_rec = 0.2,
                sigma_obs = 0.3)
plot_it = T

# Paths
path_functions = 'ANALYSIS/CODE/functions'
path_out = 'ANALYSIS/RESULTS/vectorised srm/sim_dat.RData'

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Simulate
clean_dat = sim.vrsm.data(settings, plot_it = plot_it)

# Save
save(clean_dat, file = path_out)

# Report
message(sprintf('Simulated %s calls. Saved a total of %s data points',
                clean_dat$N_call, clean_dat$N_obs))
