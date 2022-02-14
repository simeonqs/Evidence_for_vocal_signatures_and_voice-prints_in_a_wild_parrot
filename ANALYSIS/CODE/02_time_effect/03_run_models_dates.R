# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 16-10-2021
# Date last modified: 14-02-2022
# Author: Simeon Q. Smeele
# Description: Running date model on all datasets. 
# This version is updated for the 2021 data with new structure and the cmdstanr model. 
# This version is updated for the renamed objects (partially).
# This version also includes the 2020 data. 
# source('ANALYSIS/CODE/02_time_effect/03_run_models_dates.R')
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('tidyverse', 'cmdstanr')
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
load(path_data_sets_date)
data_sets_date_21$mfcc$other = NULL
data_sets_date_21$spcc$other = NULL
data_sets_date_21$specan$other = NULL
data_sets_date_21$mfcc$frill = NULL
data_sets_date_21$spcc$frill = NULL
data_sets_date_21$specan$frill = NULL

# Functions to run models
run.model = function(data_set){
  if(length(data_set) == 1) return(NA) else {
    data_set$settings = NULL
    print(length(data_set$call_i))
    fit = model$sample(data = data_set, 
                       seed = 1, 
                       chains = 4, 
                       parallel_chains = 4,
                       refresh = 2000)
    return(fit$draws())
  }
}

run.models = function(data_sets_date_sub){
  models_out = lapply(data_sets_date_sub, run.model)
  names(models_out) = names(data_sets_date_sub)
  return(models_out)
} 

# Run models
model = cmdstan_model(path_date_model)
all_models_out_date_20 = lapply(data_sets_date_20, run.models)
names(all_models_out_date_20) = c('dtw', 'mfcc', 'spcc', 'specan')
all_models_out_date_21 = lapply(data_sets_date_21, run.models)
names(all_models_out_date_21) = c('dtw', 'mfcc', 'spcc', 'specan')

# Save and message
save(all_models_out_date_20, all_models_out_date_21, file = path_date_model_results)
message('Finished all models.')