# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: chapter II
# Date started: 28-09-2021
# Date last modified: 30-09-2021
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
path_model_time = 'ANALYSIS/RESULTS/social networks model/sim_model_time.RData'
# path_pdf = 'ANALYSIS/RESULTS/social networks model/sim_results_all.pdf'

# Load model
load(path_model_time)

# Plot
post = extract.samples(model)
# pdf(path_pdf)
prior = rnorm(1e6, 0, 1) %>% density
plot(sub_dat$time, sub_dat$d, col = alpha(1+sub_dat$ind, 0.5), pch = sub_dat$rec)
for(i in 1:20) 
  lines(range(sub_dat$time), post$a_bar[i] + range(sub_dat$time) * post$b_bar[i],
        col = alpha(1, 0.2), lwd = 2)
lines(range(sub_dat$time), mean(post$a_bar) + range(sub_dat$time) * mean(post$b_bar),
      lwd = 4)
# dev.off()



