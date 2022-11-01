# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 15-03-2022
# Date last modified: 07-05-2022
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

# Open PDF
pdf(path_pdf_composite_figure, 4, 6)

# Set plot layout
set.seed(1)
layout(mat = matrix(c(1, 2,
                      3, 4,
                      5, 6,
                      7, 8, 
                      9, 10), nrow = 5, ncol = 2, byrow = T),
       heights = c(1, 1, 1, 1, 1),
       widths = c(1, 2, 1, 2, 1, 2, 1, 2, 1, 2))
par(mar = rep(0.5, 4), oma = c(4.5, 0.5, 0, 4.5))

# Run through call types
for(j in 1:5){
  
  # Plot ind model
  load( c(
    'ANALYSIS/RESULTS/01_compare_call_types/model_result_spcc_contact.RData',
    'ANALYSIS/RESULTS/01_compare_call_types/model_result_spcc_tja.RData',
    'ANALYSIS/RESULTS/01_compare_call_types/model_result_spcc_trruup.RData',
    'ANALYSIS/RESULTS/01_compare_call_types/model_result_spcc_alarm.RData',
    'ANALYSIS/RESULTS/01_compare_call_types/model_result_spcc_growl.RData'
  )[j] )
  plot(NULL, xlim = c(-0.05, 0.15), ylim = c(0, 90), main = '', 
       xlab = '', ylab = '', xaxt = 'n', yaxt = 'n')
  abline(v = 0, lty = 2, lwd = 3, col = 'grey')
  if(j == 5){
    axis(1, c(0, 0.1))
    mtext('contrast', 1, 3)
  } 
  
  a_same_rec = sapply(1:length(post$a_bar), function(i) 
    post$a_bar[i] + post$z_same_ind[i,1] * post$sigma_same_ind[i] + 
      post$z_same_rec[i,1] * post$sigma_same_rec[i])
  
  a_same_ind = sapply(1:length(post$a_bar), function(i) 
    post$a_bar[i] + post$z_same_ind[i,1] * post$sigma_same_ind[i] + 
      post$z_same_rec[i,2] * post$sigma_same_rec[i])
  
  a_diff_ind = sapply(1:length(post$a_bar), function(i) 
    post$a_bar[i] + post$z_same_ind[i,2] * post$sigma_same_ind[i] + 
      post$z_same_rec[i,2] * post$sigma_same_rec[i])
  
  lines(density(a_diff_ind - a_same_ind), col = 3, lwd = 5, lty = 1)
  lines(density(a_diff_ind - a_same_rec), col = 4, lwd = 5, lty = 1)
  
  # Plot time models
  plot(NULL, xlim = c(-7, 7), ylim = c(0.45, 0.95), main = '', 
       xlab = '', 
       ylab = '', xaxt = 'n', yaxt = 'n')
  axis(4, c(0.5, 0.7, 0.9))
  if(j == 3) mtext('acoustic distance', 4, 3)
  if(j == 5){
    mtext(' time [s]         time [days]',
          1, 3)
    axis(1, c(-7, -4, -1, 1, 4, 7), c(0.01, 0.32, 10, 0, 15, 30))
  }
  lines(c(0, 0), c(0.45, 0.95), lwd = 2)  
  
  load( c(
    'ANALYSIS/RESULTS/02_time_effect/model_result_time_spcc_contact_post.RData',
    'ANALYSIS/RESULTS/02_time_effect/model_result_time_spcc_tja_post.RData',
    'ANALYSIS/RESULTS/02_time_effect/model_result_time_spcc_trruup_post.RData',
    'ANALYSIS/RESULTS/02_time_effect/model_result_time_spcc_alarm_post.RData',
    'ANALYSIS/RESULTS/02_time_effect/model_result_time_spcc_growl_post.RData'
  )[j] )
  for(i in sample(1:length(post$a_bar), 20)) 
    lines(c(-7, -1), post[['a_bar']][i] + c(-2, 1) * post[['b_bar']][i], 
          col = 4, lwd = 5, lty = 1)
  
  load( c(
    'ANALYSIS/RESULTS/02_time_effect/model_results_date_spcc_contact_post.RData',
    'ANALYSIS/RESULTS/02_time_effect/model_results_date_spcc_tja_post.RData',
    'ANALYSIS/RESULTS/02_time_effect/model_results_date_spcc_trruup_post.RData',
    'ANALYSIS/RESULTS/02_time_effect/model_results_date_spcc_alarm_post.RData',
    'ANALYSIS/RESULTS/02_time_effect/model_results_date_spcc_growl_post.RData'
  )[j] )
  for(i in sample(1:length(post$a_bar), 20)) 
    lines(c(1, 7), post[['a_bar']][i] + c(0, 1) * post[['b_bar']][i], 
          col = 3, lwd = 5, lty = 1)
  
} # end i loop

# Save PDF
dev.off()
