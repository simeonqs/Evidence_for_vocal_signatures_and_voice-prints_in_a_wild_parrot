# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 27-04-2022
# Date last modified: 27-04-2022
# Author: Simeon Q. Smeele
# Description: Testing new way of visualisation. 
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

# Load data
load(path_data)

# List models
models = list.files(str_remove(path_out_vsrm, '/vsrm'), '*vsrm*', full.names = T)

# Load
load(models[10])

# Get values for rescale
mi = min(clean_dat$acc_dist) # - 4 ### FIX THIS, SAVE THE MIN BEFORE CLEANING ###
ma = max(clean_dat$acc_dist - mi)
rs = function(va) (va - mi) / ma
dens(rs(clean_dat$acc_dist), xlim = c(0, 1))

a_diff_ind = sapply(1:length(post$a_bar), function(i) 
  post$a_bar[i] + post$z_same_ind[i,2] * post$sigma_same_ind[i] + post$z_same_rec[i,2] * post$sigma_same_rec[i])
plot(NULL, xlim = c(0, 1), ylim = c(0, 60), xlab = 'accoustic distance', ylab = 'density')
polygon(density(rs(a_diff_ind)), col = alpha('#CC0000', 0.5), border = NA)
# lines(d, lwd = 3, col = alpha('#CC0000', 0.9))

a_same_rec = sapply(1:length(post$a_bar), function(i) 
  post$a_bar[i] + post$z_same_ind[i,1] * post$sigma_same_ind[i] + post$z_same_rec[i,1] * post$sigma_same_rec[i])
polygon(density(rs(a_same_rec)), col = alpha('black', 0.5), border = NA)

a_same_ind = sapply(1:length(post$a_bar), function(i) 
  post$a_bar[i] + post$z_same_ind[i,1] * post$sigma_same_ind[i] + post$z_same_rec[i,2] * post$sigma_same_rec[i])
polygon(density(rs(a_same_ind)), col = alpha('#000099', 0.5), border = NA)

plot(NULL, xlim = c(-0.1, 0.3), ylim = c(0, 30), xlab = 'contrast accoustic distance', ylab = 'density')
d = density(rs(a_diff_ind) - rs(a_same_ind))
dr = d
dr$y = d$y[d$x >= 0]
dr$x = d$x[d$x >= 0]
dr$y = c(0, dr$y)
dr$x = c(0, dr$x)
polygon(d, col = alpha('#000099', 0.5), border = alpha('#000099', 0.7))
# polygon(dr, col = alpha('#000099', 0.7), border = alpha('#000099', 0.7))
polygon(density(rs(a_diff_ind) - rs(a_same_rec)), col = alpha('#CC0000', 0.5), border = NA)
abline(v = 0, lty = 2, lwd = 3, col = alpha('black', 0.5))

