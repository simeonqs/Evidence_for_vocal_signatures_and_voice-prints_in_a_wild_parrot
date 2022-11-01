# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: chapter II
# Date started: 24-08-2021
# Date last modified: 24-08-2021
# Author: Simeon Q. Smeele
# Description: Plotting the output of the real data and model. 
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
path_data = 'ANALYSIS/RESULTS/social networks model/real_dat.RData'
path_model = 'ANALYSIS/RESULTS/social networks model/real_model.RData'
path_pdf = 'ANALYSIS/RESULTS/social networks model/real_results.pdf'

# Load data
load(path_data)
load(path_model)
post = extract.samples(model)

# Plot
# pdf(path_pdf)
prior = rnorm(1e6, 0, 1) %>% density
plot(prior, xlim = c(-2, 2), ylim = c(0, 5), main = '', 
     xlab = '', ylab = 'density')
polygon(prior, col = alpha('grey', 0.5))
post$b_bar_rec %>% density %>% polygon(col = alpha(2, 0.8))
post$b_bar_ind %>% density %>% polygon(col = alpha(4, 0.8))
# dev.off()

