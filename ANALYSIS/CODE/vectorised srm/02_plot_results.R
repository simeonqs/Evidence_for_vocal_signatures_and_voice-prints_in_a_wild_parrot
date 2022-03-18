# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 16-03-2022
# Date last modified: 17-03-2022
# Author: Simeon Q. Smeele
# Description: Plotting the results. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('cmdstanr')
for(lib in libraries){
  if(! lib %in% installed.packages()) lapply(lib, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Paths
path_model_results = 'ANALYSIS/RESULTS/vectorised srm/post.RData'
path_data = 'ANALYSIS/RESULTS/vectorised srm/sim_dat.RData'

# Load simulated data
load(path_data)
load(path_model_results)

# Plot same ind
par(mfrow = c(2, 2))
plot(clean_dat$same_ind, clean_dat$acc_dist, main = 'same ind')
for(i in sample(1:length(post$a_bar), 10)) 
  points(1, post$a_bar[i] + post$z_same_ind[i, 1] * post$sigma_same_ind[i],
         col = 'red')
for(i in sample(1:length(post$a_bar), 10)) 
  points(2, post$a_bar[i] + post$z_same_ind[i, 2] * post$sigma_same_ind[i],
         col = 'red')
points(1, mean(sapply(1:length(post$a_bar), function(i) 
  post$a_bar[i] + post$z_same_ind[i, 1] * post$sigma_same_ind[i])),
  col = 'red', pch = 16)
points(2, mean(sapply(1:length(post$a_bar), function(i) 
  post$a_bar[i] + post$z_same_ind[i, 2] * post$sigma_same_ind[i])),
  col = 'red', pch = 16)

# Plot same rec
plot(clean_dat$same_rec, clean_dat$acc_dist, main = 'same rec')
for(i in sample(1:length(post$a_bar), 10)) 
  points(1, post$a_bar[i] + post$z_same_rec[i, 1] * post$sigma_same_rec[i],
         col = 'red')
for(i in sample(1:length(post$a_bar), 10)) 
  points(2, post$a_bar[i] + post$z_same_rec[i, 2] * post$sigma_same_rec[i],
         col = 'red')
points(1, mean(sapply(1:length(post$a_bar), function(i) 
  post$a_bar[i] + post$z_same_rec[i, 1] * post$sigma_same_rec[i])),
  col = 'red', pch = 16)
points(2, mean(sapply(1:length(post$a_bar), function(i) 
  post$a_bar[i] + post$z_same_rec[i, 2] * post$sigma_same_rec[i])),
  col = 'red', pch = 16)

# Plot ind pairs
plot(clean_dat$ind_pair, clean_dat$acc_dist)
for(i in sample(1:length(post$a_bar), 10)) 
  for(j in 1:ncol(post$z_ind_pair))
    points(j, post$a_bar[i] + post$z_ind_pair[i, j] * post$sigma_ind_pair[i] + 
             post$z_same_ind[i, clean_dat$same_ind[clean_dat$ind_pair == j][1]] * post$sigma_same_ind[i],
           col = 'red')

# # Plot ind pairs
# plot(clean_dat$rec_pair, clean_dat$acc_dist)
# for(i in sample(1:length(post$a_bar), 10)) 
#   for(j in 1:ncol(post$z_rec_pair))
#     points(j, post$a_bar[i] + post$z_rec_pair[i, j] * post$sigma_rec_pair[i] + 
#              post$z_same_rec[i, clean_dat$same_rec[clean_dat$rec_pair == j][1]] * post$sigma_same_rec[i],
#            col = 'red')

# Plot precis
post$lp__ = NULL
plot(precis(post, depth = 1))


# Plot pairs
if(F){
  pdf('~/Desktop/test.pdf', 10, 10)
  library(tidyverse)
  df = fit$draws(format = 'df')
  df = df[,!str_detect(names(df), 'rec')]
  df = df[,!str_detect(names(df), 'call')]
  plot(df)
  dev.off()
  
  t = abs(round(cor(fit$draws(format = 'df')), 2))
  diag(t) = 0
  rm = apply(t[], 1, max)
  t[rm > 0.5, rm > 0.5]
}
