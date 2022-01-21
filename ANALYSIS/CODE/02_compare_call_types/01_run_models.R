# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 11-10-2021
# Date last modified: 19-01-2022
# Author: Simeon Q. Smeele
# Description: Modelling the data. 
# This version is updated for the 2021 data. 
# NOTE: subsetting for now. 
# source('ANALYSIS/CODE/02_compare_call_types/01_run_models.R')
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('rethinking', 'warbleR', 'MASS', 'tidyverse', 'readxl', 'umap', 'ape', 'cmdstanr')
for(lib in libraries){
  if(! lib %in% installed.packages()) lapply(lib, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Clean R
rm(list=ls()) 

# Paths
path_functions = 'ANALYSIS/CODE/functions'
path_model_10 = 'ANALYSIS/CODE/social networks model/m_10.stan'
path_out = 'ANALYSIS/RESULTS/02_compare_call_types/all_models_out.RData'
path_data = 'ANALYSIS/RESULTS/00_run_methods/all_data.RData'
path_dtw = 'ANALYSIS/RESULTS/00_run_methods/dtw/m_list.RData'
path_spcc = 'ANALYSIS/RESULTS/00_run_methods/spcc/m_list.RData'
path_mfcc = 'ANALYSIS/RESULTS/00_run_methods/mfcc/m_list.RData'
path_specan = 'ANALYSIS/RESULTS/00_run_methods/specan/m_list.RData'

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Load data
load(path_data)

# Function to run models
run.models = function(path){
  
  # Load data
  load(path)
  message(sprintf('Running models for %s...', path))
  
  # Run through all datasets and save model output
  model = cmdstan_model(path_model_10)
  models_out = lapply(m_list, function(m){
    
    # Clean data, REMEMBER TO REMOVE SUBSETTING
    n = rownames(m)
    subber = 1:length(n)
    if(length(n) > 200) subber = sample(length(n), 200) else subber = 1:length(n)
    inds = as.integer(as.factor(st[n,]$bird[subber]))
    recs = as.integer(as.factor(paste(st[n,]$bird[subber], st[n,]$file[subber])))
    d = m.to.df(m[subber, subber], inds, recs, clean_data = T)
    
    # Run models
    fit = model$sample(data = d, 
                       seed = 1, 
                       chains = 4, 
                       parallel_chains = 4,
                       refresh = 100)
    return(fit$draws())
    
  }) # end function to run single model
  
  return(models_out)
  
  message('Done!')
  
} # end run.models

# Run through all methods
all_models_out = lapply(c(path_dtw, path_mfcc, path_spcc, path_specan), run.models)
names(all_models_out) = c('dtw', 'mfcc', 'spcc', 'specan')

# Save
save(all_models_out, file = path_out)
message('Finished, saved all results.')