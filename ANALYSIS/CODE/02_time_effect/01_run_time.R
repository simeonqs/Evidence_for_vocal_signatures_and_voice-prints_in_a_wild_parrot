# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 21-03-2022
# Date last modified: 01-02-2022
# Author: Simeon Q. Smeele
# Description: Prepping data and running vsr model time. 
# source('ANALYSIS/CODE/02_time_effect/01_run_time.R')
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('tidyverse', 'cmdstanr', 'rethinking')
for(lib in libraries){
  if(! lib %in% installed.packages()) lapply(lib, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Clean R
rm(list=ls()) 

# Paths
source('ANALYSIS/CODE/paths.R')

# Load data
load(path_data)

# Functions
prep.dat = function(m, st){
  
  # Get data
  n = rownames(m)
  inds = st[n,]$bird
  recs = paste(st[n,]$bird, st[n,]$file)
  time_saver = st[n,]$Begin.Time..s./60 # time in minutes, gets log_10 transformed later
  
  # Clean data
  clean_dat = data.frame(acc_dist = as.vector(as.dist(m)))
  ## getting dimensions
  l = nrow(m)
  c = combn(1:l, 2)
  ## call
  clean_dat$call_i = c[1,]
  clean_dat$call_j = c[2,]
  ## time
  clean_dat$time_diff_log = log10(abs(time_saver[c[1,]] - time_saver[c[2,]]))
  ## rec
  clean_dat$rec = recs[c[1,]] %>% as.factor %>% as.integer
  ## ind
  clean_dat$ind = inds[c[1,]] %>% as.factor %>% as.integer
  ## remove across rec (and therefore ind)
  clean_dat = clean_dat[recs[c[1,]] == recs[c[2,]],]
  ## redo integers calls
  call_trans = 1:length(unique(c(clean_dat$call_i, clean_dat$call_j)))
  names(call_trans) = as.character(unique(c(clean_dat$call_i, clean_dat$call_j)))
  clean_dat$call_i = call_trans[as.character(clean_dat$call_i)]
  clean_dat$call_j = call_trans[as.character(clean_dat$call_j)]
  ## sample sizes
  clean_dat = as.list(clean_dat)
  clean_dat$N_call = max(clean_dat$call_j)
  clean_dat$N_ind = max(clean_dat$ind)
  clean_dat$N_rec = max(clean_dat$rec)
  clean_dat$N_obs = length(clean_dat$call_i)
  
  return(clean_dat)
  
}

run.model = function(m_list, st, method, type){
  
  message('Cleaning data...')
  clean_dat = prep.dat(m_list[[type]], st)
  message('Done.')
  
  message(sprintf('Running model for %s - %s with %s samples...', type, method, clean_dat$N_obs))
  message('Done.')
  fit = model$sample(data = clean_dat, 
                     seed = 1, 
                     chains = 4, 
                     parallel_chains = 4,
                     refresh = 2000, 
                     adapt_delta = 0.99,
                     max_treedepth = 15)
  fit$output_files() %>%
    rstan::read_stan_csv() %>%
    rethinking::extract.samples() -> post
  save(post, clean_dat, file = sprintf('%s_%s_%s_post.RData', path_time_model_results, method, type))
  print(precis(post))
  
}

# Running models
model = cmdstan_model(path_time_model)
load(path_spcc_m_list)
# run.model(m_list, st, 'spcc', 'contact')
run.model(m_list, st, 'spcc', 'tja')
# run.model(m_list, st, 'spcc', 'trruup')
# run.model(m_list, st, 'spcc', 'alarm')
# run.model(m_list, st, 'spcc', 'growl')
message('All done!')