# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 30-01-2022
# Date last modified: 30-01-2022
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
source('ANALYSIS/CODE/paths.R')

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Load data
load(path_year_model_results)
load(path_data_sets_year)

post = all_models_out_year
post_flat = apply(post, 3, rbind)
plot(NULL, xlim = c(-0.5, 1.5), ylim = c(0, 10), main = '', 
     xlab = 'beta year', ylab = 'density')
abline(v = 0, col = alpha(1, 0.5), lwd = 5, lty = 2)
post_flat[,'b_bar'] %>% density %>% lines(col = alpha(6, 1), lwd = 5, lty = 1)
text(1.5, 9, sprintf('N = %s', length(which(str_detect(colnames(post_flat), 'z_call')))), adj = 1)