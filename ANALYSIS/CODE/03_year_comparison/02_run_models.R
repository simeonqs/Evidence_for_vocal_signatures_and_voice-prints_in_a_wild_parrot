# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 30-01-2022
# Date last modified: 30-01-2022
# Author: Simeon Q. Smeele
# Description: Running date model on all datasets. 
# source('ANALYSIS/CODE/03_year_comparison/02_run_models.R')
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
load(path_data_sets_year)

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

run.models = function(data_sets_year_sub){
  models_out = lapply(data_sets_year_sub, run.model)
  names(models_out) = names(data_sets_year_sub)
  return(models_out)
} 

# Run models
model = cmdstan_model(path_year_model)
all_models_out_year = run.model(data_sets_year)
# all_models_out_year = lapply(data_sets_date_21, run.models)
# names(all_models_out_year) = c('dtw', 'mfcc', 'spcc', 'specan')

# Save and message
save(all_models_out_year, file = path_year_model_results)
message('Finished all models.')