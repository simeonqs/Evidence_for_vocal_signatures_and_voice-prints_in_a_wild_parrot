# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 20-10-2021
# Date last modified: 20-10-2021
# Author: Simeon Q. Smeele
# Description: Running sn model per call type. 
# NOTE: subsetting per call type for now!
# source('ANALYSIS/CODE/00_run_methods/specan/01_run_sn_models.R')
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('rethinking', 'tidyverse')
for(lib in libraries){
  if(! lib %in% installed.packages()) lapply(lib, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Clean R
rm(list=ls()) 

# Paths
path_data = 'ANALYSIS/RESULTS/00_run_methods/specan/results.RData'
path_model = 'ANALYSIS/CODE/social networks model/m_10.stan'
path_functions = 'ANALYSIS/CODE/functions'
path_out = 'ANALYSIS/RESULTS/00_run_methods/specan/model_results.RData'

# Settings
N_obs = 200

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Load data
load(path_data)

# Run models
set.seed(1)
model_results_specan = lapply(1:length(data_sets), function(i) 
  run.sn.model(data_sets[[i]], specan_dists[[i]], path_model, N_obs = N_obs))
names(model_results_specan) = names(data_sets)

# Save
save(model_results_specan, data_sets, file = path_out)