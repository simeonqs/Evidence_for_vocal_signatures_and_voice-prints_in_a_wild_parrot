# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 11-10-2021
# Date last modified: 02-03-2022
# Author: Simeon Q. Smeele
# Description: Modelling the data. 
# This version is updated for the 2021 data. 
# This version also includes the 2020 data. 
# This version saves diagnostics, data and post in normal format. 
# NOTE: subsetting for now. 
# source('ANALYSIS/CODE/02_compare_call_types/01_run_models.R')
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('cmdstanr', 'rstan', 'rethinking')
for(lib in libraries){
  if(! lib %in% installed.packages()) lapply(lib, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Clean R
rm(list=ls()) 

# Paths
source('ANALYSIS/CODE/paths.R')

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Load data
load(path_data)

# Function to run single model
run.single.model = function(m, st){
  # Clean data, REMEMBER TO REMOVE SUBSETTING
  n = rownames(m)
  subber = 1:length(n)
  if(length(n) > 200) subber = sample(length(n), 200) else subber = 1:length(n)
  inds = as.integer(as.factor(st[n,]$bird[subber]))
  recs = as.integer(as.factor(paste(st[n,]$bird[subber], st[n,]$file[subber])))
  d = m.to.df(m[subber, subber], inds, recs, clean_data = T)
  fit = model$sample(data = d, 
                     seed = 1, 
                     chains = 4, 
                     parallel_chains = 4,
                     refresh = 2000, 
                     adapt_delta = 0.95)
  diag = fit$cmdstan_diagnose()  
  post = fit$output_files() %>%
    rstan::read_stan_csv() %>%
    rethinking::extract.samples()
  out = list(post = post,
             diag = diag, 
             d = d)
  return(out)
}


# Function to run models
run.models = function(path){
  
  # Load data
  load(path)
  message(sprintf('Running models for %s...', path))
  
  # Run through all datasets and save model output
  models_out_20 = lapply(m_list_20, run.single.model, st_20)
  models_out_21 = lapply(m_list_21, run.single.model, st_21)
  models_out = list(models_out_20 = models_out_20, 
                    models_out_21 = models_out_21)
  
  return(models_out)
  
  message('Done!')
  
} # end run.models

# Run through all methods
model = cmdstan_model(path_model_10)
all_models_out = lapply(c(path_dtw_m_list, path_mfcc_m_list, path_spcc_m_list, path_specan_m_list), 
                        run.models)
names(all_models_out) = c('dtw', 'mfcc', 'spcc', 'specan')

# Save
save(all_models_out, file = path_ind_model_results)
message('Finished, saved all results.')