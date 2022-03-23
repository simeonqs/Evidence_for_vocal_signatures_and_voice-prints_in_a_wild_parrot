# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 22-03-2022
# Date last modified: 22-03-2022
# Author: Simeon Q. Smeele
# Description: Prepping data and running vsr model dates. 
# source('ANALYSIS/CODE/02_time_effect/06_run_vsrm_dates.R')
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
path_out = 'ANALYSIS/RESULTS/02_time_effect/vsrm_dates'
path_model = 'ANALYSIS/CODE/vectorised srm/m_dates_1.stan'

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Load data
load(path_data)

# Functions
prep.dat = function(m, st){
  
  # Get data
  n = rownames(m)
  inds = st[n,]$bird
  recs = paste(st[n,]$bird, st[n,]$file)
  day_saver =  st[n,]$file %>% str_sub(1, 10) %>% str_replace_all('_', '-') %>% as.Date %>% as.numeric
  
  # Clean data
  clean_dat = data.frame(acc_dist = as.vector(as.dist(m)))
  ## getting dimensions
  l = nrow(m)
  c = combn(1:l, 2)
  ## call
  clean_dat$call_i = c[1,]
  clean_dat$call_j = c[2,]
  ## dates
  clean_dat$month_diff = abs(day_saver[c[1,]] - day_saver[c[2,]])/30
  ## rec pair
  clean_dat$rec_pair = sapply(1:ncol(c), function(x) 
    paste(sort(c(recs[c[1,x]], recs[c[2,x]])), collapse = ' '))
  ## ind
  clean_dat$ind = inds[c[1,]]
  ## remove across ind and remove within rec and across years
  year_1 = paste(st[n,]$bird, st[n,]$file)[c[1,]] %>% str_split(' ') %>% sapply(`[`, 2) %>% 
    str_split('_') %>% sapply(`[`, 1)
  year_2 = paste(st[n,]$bird, st[n,]$file)[c[2,]] %>% str_split(' ') %>% sapply(`[`, 2) %>% 
    str_split('_') %>% sapply(`[`, 1)
  clean_dat = clean_dat[inds[c[1,]] == inds[c[2,]] &
                          recs[c[1,]] != recs[c[2,]] &
                          year_1 == year_2,]
  ## redo integers
  clean_dat$ind = as.integer(as.factor(clean_dat$ind))
  clean_dat$rec_pair = as.integer(as.factor(clean_dat$rec_pair))
  call_trans = 1:length(unique(c(clean_dat$call_i, clean_dat$call_j)))
  names(call_trans) = as.character(unique(c(clean_dat$call_i, clean_dat$call_j)))
  clean_dat$call_i = call_trans[as.character(clean_dat$call_i)]
  clean_dat$call_j = call_trans[as.character(clean_dat$call_j)]
  ## scale
  clean_dat$acc_dist = as.vector(scale(clean_dat$acc_dist))
  ## sample sizes
  clean_dat = as.list(clean_dat)
  clean_dat$N_call = max(clean_dat$call_j)
  clean_dat$N_ind = max(clean_dat$ind)
  clean_dat$N_rec_pair = max(clean_dat$rec_pair)
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
  fit$output_files() |>
    rstan::read_stan_csv() |>
    rethinking::extract.samples() -> post
  save(post, clean_dat, file = sprintf('%s_%s_%s_post.RData', path_out, method, type))
  print(precis(post))
  
}

# Running models
model = cmdstan_model(path_model)
load(path_dtw_m_list)
run.model(m_list, st, 'dtw', 'contact')
# run.model(m_list, st, 'dtw', 'trruup')
message('All done!')