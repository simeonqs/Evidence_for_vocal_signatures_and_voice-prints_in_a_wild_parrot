# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 21-03-2022
# Date last modified: 21-03-2022
# Author: Simeon Q. Smeele
# Description: Run the model for time. 
# source('ANALYSIS/CODE/vectorised srm/08_run_model_dates.R')
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('cmdstanr', 'rethinking')
for(lib in libraries){
  if(! lib %in% installed.packages()) lapply(lib, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Paths
path_functions = 'ANALYSIS/CODE/functions'
path_data = 'ANALYSIS/RESULTS/vectorised srm/sim_dat_dates.RData'
path_out = 'ANALYSIS/RESULTS/vectorised srm/model_dates.RData'
path_model = 'ANALYSIS/CODE/vectorised srm/m_dates_1.stan'

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Run model
load(path_data)
model = cmdstan_model(path_model)
fit = model$sample(data = clean_dat, 
                   seed = 1, 
                   chains = 4, 
                   parallel_chains = 4,
                   refresh = 2000, 
                   adapt_delta = 0.99,
                   max_treedepth = 15)
fit$output_files() |>
  rstan::read_stan_csv() |>
  rethinking::extract.samples() -> post
save(post, file = path_out)
print(precis(post))
message('Done.')