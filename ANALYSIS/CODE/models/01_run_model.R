# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 15-03-2022
# Date last modified: 15-03-2022
# Author: Simeon Q. Smeele
# Description: Running the vectorised model on simulated data.
# source('ANALYSIS/CODE/vectorised srm/01_run_model.R')
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('cmdstanr')
for(lib in libraries){
  if(! lib %in% installed.packages()) lapply(lib, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Paths
path_model = 'ANALYSIS/CODE/vectorised srm/m_5.stan'
path_data = 'ANALYSIS/RESULTS/vectorised srm/sim_dat.RData'
path_model_results = 'ANALYSIS/RESULTS/vectorised srm/post.RData'

# Toy data for now
d = list(acc_dist = c(2, 2, 1, 1, 3, 2, 2, 1, 1, 3, 
                      9, 5, 20, 10, 5, 9, 5, 20, 10, 5),
         same_ind = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                      2, 2, 2, 2, 2, 2, 2, 2, 2, 2),
         N_obs = 20)

# Load simulated data
load(path_data)

# Run model
model = cmdstan_model(path_model)
fit = model$sample(data = clean_dat, 
                   seed = 1, 
                   chains = 4, 
                   parallel_chains = 4,
                   refresh = 2000, 
                   adapt_delta = 0.99,
                   max_treedepth = 15)
print(fit$summary())
fit$output_files() |>
  rstan::read_stan_csv() |>
  rethinking::extract.samples() -> post
save(post, file = path_model_results)