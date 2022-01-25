# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 14-10-2021
# Date last modified: 24-01-2022
# Author: Simeon Q. Smeele
# Description: Running time model on all datasets. 
# This version is updated for the 2021 data with new structure and the cmdstanr model. 
# source('ANALYSIS/CODE/03_time_effect/02_run_models_time.R')
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('cmdstanr', 'tidyverse')
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
load(path_data_sets_time)

# Functions to run models
run.model = function(data_set){
  if(length(data_set) == 1) return(NA) else {
    data_set$settings = NULL
    fit = model$sample(data = data_set, 
                       seed = 1, 
                       chains = 4, 
                       parallel_chains = 4,
                       refresh = 2000)
    return(fit$draws())
  }
}

run.models = function(data_sets_time_sub){
  models_out = lapply(data_sets_time_sub, run.model)
  names(models_out) = names(data_sets_time_sub)
  return(models_out)
} 

# Run models
model = cmdstan_model(path_time_model)
all_models_out_time = lapply(data_sets_time, run.models)
names(all_models_out_time) = c('dtw', 'mfcc', 'spcc', 'specan')

# Save and message
save(all_models_out_time, file = path_time_model_results)
message('Finished all models.')