# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: chapter II
# Date started: 28-09-2021
# Date last modified: 28-09-2021
# Author: Simeon Q. Smeele
# Description: Plotting the output of the simulated data and models including time and date.  
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
path_model_time = 'ANALYSIS/RESULTS/social networks model/sim_model_date.RData'
path_pdf = 'ANALYSIS/RESULTS/social networks model/sim_results_all.pdf'

# Load model
load(path_model_time)

# Plot
post = extract.samples(model)
pdf(path_pdf)
prior = rnorm(1e6, 0, 1) %>% density
plot(prior, xlim = c(-2, 2), ylim = c(0, 5), main = '', 
     xlab = '', ylab = 'density')
polygon(prior, col = alpha('grey', 0.5))
post$b_bar_rec %>% density %>% polygon(col = alpha(2, 0.6)) # red
post$b_bar_ind %>% density %>% polygon(col = alpha(4, 0.6)) # blue
post$b_bar_time %>% density %>% polygon(col = alpha(3, 0.6)) # green
post$b_bar_date %>% density %>% polygon(col = alpha(6, 0.6)) # purple
dev.off()



