# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 11-10-2021
# Date last modified: 12-10-2021
# Author: Simeon Q. Smeele
# Description: Visualising the results of SPCC, DTW and MFCC. 
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

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Load data
load(path_data) 

# Clean data
subber = sample(nrow(d_all), 100)
d_dtw = m.to.df(m_dtw[subber, subber], d_all$bird[subber], paste(d_all$bird[subber], d_all$file[subber]))
d_spcc = m.to.df(m_spcc[subber, subber], d_all$bird[subber], paste(d_all$bird[subber], d_all$file[subber]))
d_mfcc = m.to.df(m_mfcc[subber, subber], d_all$bird[subber], paste(d_all$bird[subber], d_all$file[subber]))

# Run models
message('Running DTW model.')
model_dtw = stan(path_model_10,
                 data = d_dtw,
                 chains = 4, cores = 4,
                 iter = 2000, warmup = 500,
                 control = list(max_treedepth = 15, adapt_delta = 0.95))
message('Here are the results of the dtw model:')
print(precis(model_dtw, depth = 1))

# Save
save('model', file = path_out)





