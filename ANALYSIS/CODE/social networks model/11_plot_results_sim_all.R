# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: chapter II
# Date started: 28-09-2021
# Date last modified: 11-10-2021
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
path_model_date = 'ANALYSIS/RESULTS/social networks model/sim_model_date.RData'
# path_pdf = 'ANALYSIS/RESULTS/social networks model/sim_results_all.pdf'

# # Load model
# load(path_model_time)
# 
# # Plot
# post = extract.samples(model)
# # pdf(path_pdf)
# prior = rnorm(1e6, 0, 1) %>% density
# plot(sub_dat$time, sub_dat$d, col = alpha(1+sub_dat$ind, 0.5), pch = sub_dat$rec)
# for(i in 1:20) 
#   lines(range(sub_dat$time), post$a_bar[i] + range(sub_dat$time) * post$b_bar[i],
#         col = alpha(1, 0.2), lwd = 2)
# lines(range(sub_dat$time), mean(post$a_bar) + range(sub_dat$time) * mean(post$b_bar),
#       lwd = 4)
# # dev.off()

# Load model
load(path_model_date)

# Plot
post = extract.samples(model)
# pdf(path_pdf)
plot(sub_dat$date, sub_dat$d, col = alpha(1+sub_dat$ind, 0.5))
for(i in sample(length(post$a_bar), 20)) 
  lines(range(sub_dat$date), post$a_bar[i] + range(sub_dat$date) * post$b_bar[i],
        col = alpha(1, 0.3), lwd = 2)
for(i in seq_along(unique(sub_dat$ind_per_rec)))
  for(j in sample(length(post$a_bar), 20))
    lines(range(sub_dat$date), 
          sapply(range(sub_dat$date), function(x)
            post$a_bar[j] + post$z_ind[j,i] * post$sigma_z_ind[j] + 
              (post$b_bar[j] + post$b_ind[j,i] * post$sigma_b_ind[j]) * x),
          lwd = 2, col = alpha(i + 1, 0.1))
for(i in seq_along(unique(sub_dat$ind_per_rec)))
  lines(range(sub_dat$date), 
        apply(sapply(range(sub_dat$date), function(x)
          post$a_bar + post$z_ind[,i] * post$sigma_z_ind + 
            (post$b_bar + post$b_ind[,i] * post$sigma_b_ind) * x), 2, mean),
        lwd = 3, col = i + 1)
lines(range(sub_dat$date), mean(post$a_bar) + range(sub_dat$date) * mean(post$b_bar),
      lwd = 5)
# dev.off()

