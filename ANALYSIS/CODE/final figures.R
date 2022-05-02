# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 15-03-2022
# Date last modified: 30-04-2022
# Author: Simeon Q. Smeele
# Description: Plotting the final figures for the paper.
# This version has a completely new figure that combines all the Bayesian results. 
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

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Open PDF
pdf('~/Desktop/test.pdf', 7, 3)

# Set plot layout
layout(mat = matrix(c(1, 2), nrow = 1, ncol = 2),
       heights = c(1),    
       widths = c(1, 2)) 
par(mar = c(5, 5, 1, 1))

# Plot ind model
load('ANALYSIS/RESULTS/01_compare_call_types/vsrm_spcc_contact.RData')
plot(NULL, ylim = c(-3, 1), xlim = c(0, 10), main = '', 
     xlab = 'density', ylab = 'acoustic distance', xaxt = 'l', yaxt = 'l')
# abline(v = 0, col = alpha(1, 0.5), lwd = 5, lty = 2)

a_same_rec = sapply(1:length(post$a_bar), function(i) 
  post$a_bar[i] + post$z_same_ind[i,1] * post$sigma_same_ind[i] + 
    post$z_same_rec[i,1] * post$sigma_same_rec[i])

a_same_ind = sapply(1:length(post$a_bar), function(i) 
  post$a_bar[i] + post$z_same_ind[i,1] * post$sigma_same_ind[i] + 
    post$z_same_rec[i,2] * post$sigma_same_rec[i])

a_diff_ind = sapply(1:length(post$a_bar), function(i) 
  post$a_bar[i] + post$z_same_ind[i,2] * post$sigma_same_ind[i] + 
    post$z_same_rec[i,2] * post$sigma_same_rec[i])

density(a_diff_ind)[c('y', 'x')] %>% as.data.frame %>% lines(col = alpha('grey', 1), lwd = 5, lty = 1)
density(a_same_rec)[c('y', 'x')] %>% as.data.frame %>% lines(col = alpha(4, 1), lwd = 5, lty = 1)
density(a_same_ind)[c('y', 'x')] %>% as.data.frame %>% lines(col = alpha(3, 1), lwd = 5, lty = 1)
text(1.25, 9, sprintf('N = %s', ncol(post$z_call)), adj = 1)

# Plot time models
par(mar = c(5, 1, 1, 1))
plot(NULL, xlim = c(-7, 7), ylim = c(-3, 1), main = '', 
     xlab = 'time difference [s]                                            time difference [days]', 
     ylab = '', xaxt = 'n', yaxt = 'n')
axis(1, c(-7, -5, -3, -1, 1, 3, 5, 7), c(0.01, 0.1, 1, 10, 0, 10, 20, 30))
lines(c(0, 0), c(-3, 1), lwd = 2)  

load('ANALYSIS/RESULTS/02_time_effect/vsrm_time_spcc_contact_post.RData')
for(i in sample(1:length(post$a_bar), 20)) 
  lines(c(-7, -1), post[['a_bar']][i] + c(-2, 1) * post[['b_bar']][i], 
        col = 4, lwd = 5, lty = 1)

load('ANALYSIS/RESULTS/02_time_effect/vsrm_dates_spcc_contact_post.RData')
for(i in sample(1:length(post$a_bar), 20)) 
  lines(c(1, 7), post[['a_bar']][i] + c(0, 1) * post[['b_bar']][i], 
        col = 3, lwd = 5, lty = 1)

# Save PDF
dev.off()


