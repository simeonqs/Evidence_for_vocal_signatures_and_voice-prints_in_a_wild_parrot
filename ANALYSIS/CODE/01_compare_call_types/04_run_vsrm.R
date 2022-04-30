# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 19-03-2022
# Date last modified: 19-03-2022
# Author: Simeon Q. Smeele
# Description: Running the vectorised (but actually slower) version of the social relations model. 
# source('ANALYSIS/CODE/01_compare_call_types/04_run_vsrm.R')
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
run.single.model = function(m, st, path_out_vsrm, method, type){
  
  message(sprintf('Running %s - %s with %s calls.', method, type, nrow(m)))
  
  # Prep data
  set.seed(1)
  n = rownames(m)
  subber = 1:length(n)
  if(length(n) > 1000) subber = sample(length(n), 1000) else subber = 1:length(n)
  inds = st[n,]$bird[subber] %>% as.factor %>% as.integer
  recs = paste(st[n,]$bird[subber], st[n,]$file[subber]) %>% as.factor %>% as.integer
  m =  m[subber, subber]
  
  # Make vectors
  ## acoustic distance
  clean_dat = data.frame(acc_dist = as.vector(scale(as.vector(as.dist(m)))))
  ## getting dimensions
  l = nrow(m)
  c = combn(1:l, 2)
  ## call
  clean_dat$call_i = c[1,]
  clean_dat$call_j = c[2,]
  ## same ind = 1, else = 0
  clean_dat$same_ind = sapply(1:ncol(c), function(x) ifelse(inds[c[1,x]] == inds[c[2,x]], 1, 2))
  ## same rec = 1, else = 0
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
  save(post, clean_dat, file = sprintf('%s_%s_%s.RData', path_out_vsrm, method, type))
  
}

# Run
model = cmdstan_model(path_vsr_model)
load(path_dtw_m_list)
run.single.model(m_list$contact, st, path_out_vsrm, 'dtw', 'contact')
# run.single.model(m_list$tja, st, path_out_vsrm, 'dtw', 'tja')
# run.single.model(m_list$trruup, st, path_out_vsrm, 'dtw', 'trruup')
# load(path_spcc_m_list)
# run.single.model(m_list$contact, st, path_out_vsrm, 'spcc', 'contact')
# run.single.model(m_list$tja, st, path_out_vsrm, 'spcc', 'tja')
# run.single.model(m_list$trruup, st, path_out_vsrm, 'spcc', 'trruup')
# run.single.model(m_list$alarm, st, path_out_vsrm, 'spcc', 'alarm')
# run.single.model(m_list$growl, st, path_out_vsrm, 'spcc', 'growl')
# load(path_mfcccc_m_list)
# run.single.model(m_list$contact, st, path_out_vsrm, 'mfcccc', 'contact')
# run.single.model(m_list$tja, st, path_out_vsrm, 'mfcccc', 'tja')
# run.single.model(m_list$trruup, st, path_out_vsrm, 'mfcccc', 'trruup')
# run.single.model(m_list$alarm, st, path_out_vsrm, 'mfcccc', 'alarm')
# run.single.model(m_list$growl, st, path_out_vsrm, 'mfcccc', 'growl')
# load(path_specan_m_list)
# run.single.model(m_list$contact, st, path_out_vsrm, 'specan', 'contact')
# run.single.model(m_list$tja, st, path_out_vsrm, 'specan', 'tja')
# run.single.model(m_list$trruup, st, path_out_vsrm, 'specan', 'trruup')
# run.single.model(m_list$alarm, st, path_out_vsrm, 'specan', 'alarm')
# run.single.model(m_list$growl, st, path_out_vsrm, 'specan', 'growl')

message('Finished, saved all results.')