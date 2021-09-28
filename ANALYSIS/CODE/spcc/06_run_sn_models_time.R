# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 27-08-2021
# Date last modified: 27-09-2021
# Author: Simeon Q. Smeele
# Description: Running sn model per call type. 
# NOTE: subsetting per call type for now!
# source('ANALYSIS/CODE/spcc/06_run_sn_models_time.R')
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('rethinking', 'tidyverse', 'parallel')
for(lib in libraries){
  if(! lib %in% installed.packages()) lapply(lib, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Clean R
rm(list=ls()) 

# Paths
path_data = 'ANALYSIS/RESULTS/spcc/datasets per call type'
path_model = 'ANALYSIS/CODE/social networks model/m_13.stan'
path_functions = 'ANALYSIS/CODE/functions'
path_out = 'ANALYSIS/RESULTS/spcc/models time'

# Settings
N_obs = 250
mc.cores = 8

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# List data set paths
data_set_paths = list.files(path_data, full.names = T, pattern = '*RData')

# Run models
set.seed(1)
.out = mclapply(data_set_paths, run.sn.model, 
                path_model, path_out, N_obs = N_obs, incl_time_within = T,
                mc.cores = mc.cores)