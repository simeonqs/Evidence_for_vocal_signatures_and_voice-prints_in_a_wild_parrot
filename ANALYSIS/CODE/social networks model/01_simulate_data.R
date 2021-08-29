# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: chapter II
# Date started: 24-08-2021
# Date last modified: 28-08-2021
# Author: Simeon Q. Smeele
# Description: Simple simulation of data that we might get from dtw. 
# This version adds data to code whether or not an ind pair is the same ind. 
# This version adds the rec level. 
# This version was moved to the new repo and paths were fixed. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('data.table', 'tidyverse', 'rethinking')
for(i in libraries){
  if(! i %in% installed.packages()) lapply(i, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Settings
set.seed(3)
N_ind = 10
N_var = 5
lambda_rec = 2
lambda_obs = 3
sigma_ind = 1
sigma_rec = 0.5
sigma_obs = 0.1

# Paths
path_functions = 'ANALYSIS/CODE/functions'
path_out = 'ANALYSIS/RESULTS/luscinia/social networks model/sim_dat.RData'

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Simulate
recs = c()
inds = c()
dat = data.frame()
for(ind in 1:N_ind){
  means_ind = rnorm(N_var, 0, sigma_ind)
  N_rec = rpois(1, lambda_rec)
  if(N_rec == 0) next
  for(rec in 1:N_rec){
    means_rec = rnorm(N_var, means_ind, sigma_rec)
    N_obs = rpois(1, lambda_obs)
    if(N_obs == 0) next
    for(obs in 1:N_obs){
      recs = c(recs, paste(ind, rec))
      inds = c(inds, ind)
      dat = rbind(dat, rnorm(N_var, means_rec, sigma_obs))
    }
  }
}
inds = as.integer(as.factor(inds))
recs = as.integer(as.factor(recs))

# Plot first two variables
plot(dat[,1], dat[,2], pch = 16, col = inds)

# Make into distance matrix
names(dat) = paste0('x', 1:ncol(dat))
m = as.matrix(dist(dat))
d = m.to.df(m, inds, recs)

# List data
clean_dat = as.list(d)
clean_dat$d = as.numeric(scale(d$d)) # smaller values = closer = more similar
clean_dat$N_ind_pair = max(d$ind_pair)
clean_dat$N_rec_pair = max(d$rec_pair)
clean_dat$N_ind = max(d$ind_i)
clean_dat$N_rec = max(d$rec_i)
clean_dat$N_call = max(d$call_j)
clean_dat$N_obs = length(d$call_i)
clean_dat$same_ind = sapply(1:max(d$ind_pair), function(pair) # 1 = same, 0 = different
  ifelse(clean_dat$ind_i[clean_dat$ind_pair == pair][1] == 
           clean_dat$ind_j[clean_dat$ind_pair == pair][1], 1, 0))

# Save
save(clean_dat, file = path_out)

# Report
message(sprintf('Simulated data for %s individuals. Saved a total of %s data points',
                clean_dat$N_ind, clean_dat$N_obs))