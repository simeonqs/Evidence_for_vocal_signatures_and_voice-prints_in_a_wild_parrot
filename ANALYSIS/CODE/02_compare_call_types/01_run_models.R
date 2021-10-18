# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 11-10-2021
# Date last modified: 12-10-2021
# Author: Simeon Q. Smeele
# Description: Modeling the data.  
# NOTE: subsetting for now. 
# source('ANALYSIS/CODE/00_compare_methods/01_run_models.R')
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
path_data = 'ANALYSIS/RESULTS/00_compare_methods/objects.RData'
path_model_10 = 'ANALYSIS/CODE/social networks model/m_10.stan'
path_out = 'ANALYSIS/RESULTS/00_compare_methods/models.RData'

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Load data
load(path_data) 

# Clean data
message('Cleaning data.')
subber = sample(nrow(d_all), 100)
inds = as.integer(as.factor(d_all$bird[subber]))
recs = as.integer(as.factor(paste(d_all$bird[subber], d_all$file[subber])))
d_dtw = m.to.df(m_dtw[subber, subber], inds, recs, clean_data = T)
d_spcc = m.to.df(m_spcc[subber, subber], inds, recs, clean_data = T)
d_mfcc = m.to.df(m_mfcc[subber, subber], inds, recs, clean_data = T)

# Run models
message('Running DTW model.')
model_dtw = stan(path_model_10,
                 data = d_dtw,
                 chains = 4, cores = 4,
                 iter = 2000, warmup = 500,
                 control = list(max_treedepth = 15, adapt_delta = 0.95))
message('Here are the results of the DTW model:')
print(precis(model_dtw, depth = 1))

message('Running SPCC model.')
model_spcc = stan(path_model_10,
                  data = d_spcc,
                  chains = 4, cores = 4,
                  iter = 2000, warmup = 500,
                  control = list(max_treedepth = 15, adapt_delta = 0.95))
message('Here are the results of the SPCC model:')
print(precis(model_spcc, depth = 1))

message('Running MFCC model.')
model_mfcc = stan(path_model_10,
                  data = d_mfcc,
                  chains = 4, cores = 4,
                  iter = 2000, warmup = 500,
                  control = list(max_treedepth = 15, adapt_delta = 0.95))
message('Here are the results of the MFCC model:')
print(precis(model_mfcc, depth = 1))

# Save
save(model_dtw, model_spcc, model_mfcc, file = path_out)
message('Finished, saved all results.')