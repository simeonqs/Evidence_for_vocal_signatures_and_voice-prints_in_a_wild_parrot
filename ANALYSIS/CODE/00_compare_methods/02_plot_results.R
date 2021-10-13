# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 12-10-2021
# Date last modified: 12-10-2021
# Author: Simeon Q. Smeele
# Description: Plotting model results per method.  
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
path_models = 'ANALYSIS/RESULTS/00_compare_methods/models.RData'
path_functions = 'ANALYSIS/CODE/functions'
path_pdf = 'ANALYSIS/RESULTS/00_compare_methods/model results.pdf'

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Load data
load(path_models)

# Plot beta parameter per call type
pdf(path_pdf, 9, 3)
par(mfrow = c(1, 3))
for(i in 1:3){
  model = list(model_dtw, model_spcc, model_mfcc)[[i]]
  name_data = c('DTW', 'SPCC', 'MFCC')[i]
  post = extract.samples(model)
  prior = rnorm(1e6, 0, 1) %>% density
  plot(prior, xlim = c(-2, 2), ylim = c(0, 5), main = name_data, 
       xlab = 'beta', ylab = 'density')
  polygon(prior, col = alpha('grey', 0.5))
  post$b_bar_rec %>% density %>% polygon(col = alpha(2, 0.8))
  post$b_bar_ind %>% density %>% polygon(col = alpha(4, 0.8))
  text(-2, 4.5, sprintf('N = %s', ncol(post$z_call)), adj = 0)
  text(c(-2, -2), c(1, 2), c('beta individual', 'beta recording'), col = c(2, 4), adj = 0)
}
dev.off()