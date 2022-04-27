# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 28-08-2021
# Date last modified: 03-09-2021
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
path_model = 'ANALYSIS/RESULTS/social networks model/real_model.RData'
path_data = 'ANALYSIS/RESULTS/social networks model/real_dat.RData'

# Load data
load(path_model)
load(path_data)
post = extract.samples(model)

# Plot precis
plot(precis(model))

# Compare slope to prior
prior = rnorm(1e6, 0, 1) %>% density
plot(prior, xlim = c(-3, 3), ylim = c(0, 10), main = '',
     xlab = '', ylab = 'density')
polygon(prior, col = alpha('grey', 0.5))
post$b_bar %>% density %>% polygon(col = alpha(4, 0.8))

# Check means for b
mb = apply(post$b_ind_pair, 2, mean)
dens(mb)
which(mb == max(mb))

# Plot real data and estimate
plot(clean_dat$d[clean_dat$ind_pair == 4086], pch = 16, ylim = c(-2, 2))
points(clean_dat$d[clean_dat$ind_pair == 4087], pch = 16, col = 2)
points(clean_dat$d[clean_dat$ind_pair == 6], pch = 16, col = 3)



