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

# Plot
post = extract.samples(model)
pdf(path_pdf)
per_pair = lapply(1:ncol(post$z_ind_pair), function(pair)
  sapply(1:nrow(post$z_ind_pair), function(i)
    post$a[i] + post$z_ind_pair[i, pair] * post$sigma_ind_pair[i]))
ind_same = sapply(1:max(clean_dat$ind_pair), function(pair) 
  ifelse(clean_dat$ind_i[clean_dat$ind_pair == pair][1] == 
           clean_dat$ind_j[clean_dat$ind_pair == pair][1], 1, 2))
plot(NULL, xlim = c(0, max(clean_dat$ind_pair)), ylim = c(-3, 3))
for(pair in 1:max(clean_dat$ind_pair)) 
  lines(rep(pair, 2), PI(per_pair[[pair]]), lwd = 3, col = alpha(ind_same[pair], 0.8))
points(sapply(per_pair, mean), 
       col = alpha(ind_same, 0.8),
       pch = 16)
plot(precis(model))
dev.off()

# Load data
load(path_data)
load(path_model)

# Plot
post = extract.samples(model)
per_pair = lapply(1:ncol(post$z_ind_pair), function(pair)
  sapply(1:nrow(post$z_ind_pair), function(i)
    post$a[i] + post$z_ind_pair[i, pair] * post$sigma_ind_pair[i]))
ind_same = sapply(1:max(clean_dat$ind_pair), function(pair) 
  ifelse(clean_dat$ind_i[clean_dat$ind_pair == pair][1] == 
           clean_dat$ind_j[clean_dat$ind_pair == pair][1], 1, 2))
plot(NULL, xlim = c(0, max(clean_dat$ind_pair)), ylim = c(-3, 3))
for(pair in 1:max(clean_dat$ind_pair)) 
  lines(rep(pair, 2), PI(per_pair[[pair]]), lwd = 3, col = alpha(ind_same[pair], 0.8))
points(sapply(per_pair, mean), 
       col = alpha(ind_same, 0.8),
       pch = 16)
