# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 14-10-2021
# Date last modified: 17-10-2021
# Author: Simeon Q. Smeele
# Description: Running time model on all datasets. 
# source('ANALYSIS/CODE/01_time_effect/02_run_models_time.R')
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('rethinking', 'warbleR', 'MASS', 'tidyverse', 'readxl', 'umap', 'ape')
for(lib in libraries){
  if(! lib %in% installed.packages()) lapply(lib, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Clean R
rm(list=ls()) 

# Paths
path_functions = 'ANALYSIS/CODE/functions'
path_time_model = 'ANALYSIS/CODE/social networks model/m_time_2.stan'
path_data = 'ANALYSIS/RESULTS/01_time_effect/data_sets_time.RData'
path_out = 'ANALYSIS/RESULTS/01_time_effect/models_time.RData'

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Load data
load(path_data)

# Function to run model
run.model = function(data_set){
  if(length(data_set) == 1) return(NA) else {
    stan(path_time_model,
         data = data_set, 
         chains = 4, cores = 4,
         iter = 2000, warmup = 500,
         control = list(max_treedepth = 15, adapt_delta = 0.95))
  }
}

# Run models
models_mfcc_time = lapply(data_sets_mfcc_time, run.model)
models_spcc_time = lapply(data_sets_spcc_time, run.model)

# Save and message
save(models_mfcc_time, models_spcc_time, file = path_out)
message('Finished all models.')