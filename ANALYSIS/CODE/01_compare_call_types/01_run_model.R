# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 19-03-2022
# Date last modified: 30-04-2022
# Author: Simeon Q. Smeele
# Description: Running the vectorised (but actually slower) version of the social relations model. 
# This version switches to normalised instead of standardised accoustic distance. 
# source('ANALYSIS/CODE/01_compare_call_types/01_run_model.R')
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('cmdstanr', 'rstan', 'rethinking', 'tidyverse')
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

# Function to run single model
run.single.model = function(m, st, path_ind_model_results, method, type){
  
  message(sprintf('Running %s - %s with %s calls.', method, type, nrow(m)))
  
  # Prep data
  set.seed(1)
  n = rownames(m)
  subber = 1:length(n)
  if(length(n) > 300) subber = sample(length(n), 300) else subber = 1:length(n)
  inds = st[n,]$bird[subber] %>% as.factor %>% as.integer
  recs = paste(st[n,]$bird[subber], st[n,]$file[subber]) %>% as.factor %>% as.integer
  m =  m[subber, subber]
  
  # Make vectors
  ## acoustic distance
  clean_dat = data.frame(acc_dist = as.vector(as.dist(m)))
  ## getting dimensions
  l = nrow(m)
  c = combn(1:l, 2)
  ## call
  clean_dat$call_i = c[1,]
  clean_dat$call_j = c[2,]
  ## same ind = 1, else = 2
  clean_dat$same_ind = sapply(1:ncol(c), function(x) ifelse(inds[c[1,x]] == inds[c[2,x]], 1, 2))
  ## same rec = 1, else = 2
  clean_dat$same_rec = sapply(1:ncol(c), function(x) ifelse(recs[c[1,x]] == recs[c[2,x]], 1, 2))
  ## ind pair
  clean_dat$ind_pair = sapply(1:ncol(c), function(x) 
    paste(sort(c(inds[c[1,x]], inds[c[2,x]])), collapse = ' ')) %>% as.factor() %>% as.integer()
  ## rec pair
  clean_dat$rec_pair = sapply(1:ncol(c), function(x) 
    paste(sort(c(recs[c[1,x]], recs[c[2,x]])), collapse = ' ')) %>% as.factor() %>% as.integer()
  
  # Remove across years
  year_1 = paste(st[n,]$bird[subber], st[n,]$file[subber])[c[1,]] %>% str_split(' ') %>% sapply(`[`, 2) %>% 
    str_split('_') %>% sapply(`[`, 1)
  year_2 = paste(st[n,]$bird[subber], st[n,]$file[subber])[c[2,]] %>% str_split(' ') %>% sapply(`[`, 2) %>% 
    str_split('_') %>% sapply(`[`, 1)
  clean_dat = clean_dat[year_1 == year_2,]
  clean_dat$ind_pair = as.integer(as.factor(clean_dat$ind_pair))
  clean_dat$rec_pair = as.integer(as.factor(clean_dat$rec_pair))
  
  # Add sample sizes
  clean_dat = as.list(clean_dat)
  clean_dat$N_ind_pair = max(clean_dat$ind_pair)
  clean_dat$N_rec_pair = max(clean_dat$rec_pair)
  clean_dat$N_call = max(clean_dat$call_j)
  clean_dat$N_obs = length(clean_dat$call_i)
  
  # Run model and save
  fit = model$sample(data = clean_dat, 
                     seed = 1, 
                     chains = 4, 
                     parallel_chains = 4,
                     refresh = 2000, 
                     adapt_delta = 0.99,
                     max_treedepth = 15)
  print(fit$summary())
  fit$output_files() %>%
    rstan::read_stan_csv() %>%
    rethinking::extract.samples() -> post
  save(post, clean_dat, file = sprintf('%s_%s_%s.RData', path_ind_model_results, method, type))
  
}

# Run
model = cmdstan_model(path_ind_model)
load(path_dtw_m_list)
# run.single.model(m_list$contact, st, path_ind_model_results, 'dtw', 'contact')
# run.single.model(m_list$tja, st, path_ind_model_results, 'dtw', 'tja')
# run.single.model(m_list$trruup, st, path_ind_model_results, 'dtw', 'trruup')
load(path_spcc_m_list)
run.single.model(m_list$contact, st, path_ind_model_results, 'spcc', 'contact')
run.single.model(m_list$tja, st, path_ind_model_results, 'spcc', 'tja')
run.single.model(m_list$trruup, st, path_ind_model_results, 'spcc', 'trruup')
run.single.model(m_list$alarm, st, path_ind_model_results, 'spcc', 'alarm')
run.single.model(m_list$growl, st, path_ind_model_results, 'spcc', 'growl')
load(path_mfcccc_m_list)
# run.single.model(m_list$contact, st, path_ind_model_results, 'mfcccc', 'contact')
# run.single.model(m_list$tja, st, path_ind_model_results, 'mfcccc', 'tja')
# run.single.model(m_list$trruup, st, path_ind_model_results, 'mfcccc', 'trruup')
# run.single.model(m_list$alarm, st, path_ind_model_results, 'mfcccc', 'alarm')
# run.single.model(m_list$growl, st, path_ind_model_results, 'mfcccc', 'growl')
load(path_specan_m_list)
# run.single.model(m_list$contact, st, path_ind_model_results, 'specan', 'contact')
# run.single.model(m_list$tja, st, path_ind_model_results, 'specan', 'tja')
# run.single.model(m_list$trruup, st, path_ind_model_results, 'specan', 'trruup')
# run.single.model(m_list$alarm, st, path_ind_model_results, 'specan', 'alarm')
# run.single.model(m_list$growl, st, path_ind_model_results, 'specan', 'growl')

message('Finished, saved all results.')