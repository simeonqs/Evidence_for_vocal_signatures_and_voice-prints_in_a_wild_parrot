# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 27-08-2021
# Date last modified: 27-08-2021
# Author: Simeon Q. Smeele
# Description: Running sna model per call type. 
# NOTE: subsetting to 10 inds per call type for now!
# source('ANALYSIS/CODE/spcc/04_run_sna_models.R')
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
path_data = 'ANALYSIS/RESULTS/spcc/datasets per call type'
path_model = 'ANALYSIS/CODE/luscinia/social networks model/m_3.stan'
path_functions = 'ANALYSIS/CODE/functions'
path_out = 'ANALYSIS/RESULTS/spcc/models'

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# List data set paths
data_set_paths = list.files(path_data, full.names = T, pattern = '*RData')

# Run models
set.seed(1)
.out = lapply(data_set_paths, run.sna.model, path_model, path_out, N_obs = 50)