# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 28-08-2021
# Date last modified: 28-08-2021
# Author: Simeon Q. Smeele
# Description: Checking the model outputs. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('rethinking', 'tidyverse')
for(i in libraries){
  if(! i %in% installed.packages()) lapply(i, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Clear R
rm(list = ls())

# Paths
path_model = 'ANALYSIS/RESULTS/luscinia/social networks model/sim_model.RData'

# Load data
load(path_model)
post = extract.samples(model)

# Compare slope to prior
prior = rexp(1e6, 2) %>% density
plot(prior, xlim = c(0, 3), ylim = c(0, 3), main = '',
     xlab = '', ylab = 'density')
polygon(prior, col = alpha('grey', 0.5))
post$b_ind_pair %>% density %>% polygon(col = alpha(4, 0.8))

