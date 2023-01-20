# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 31-10-2022
# Date last modified: 09-11-2022
# Author: Simeon Q. Smeele
# Description: Plotting the final figures for the supplemental materials.
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

# Open PDF dtw ----
pdf(path_pdf_composite_figure_dtw, 4, 3.5)

# Set plot layout
set.seed(1)
layout(mat = matrix(c(1, 2,
                      3, 4,
                      5, 6), nrow = 3, ncol = 2, byrow = T),
       heights = c(1, 1, 1),
       widths = c(1, 2, 1, 2, 1, 2))
par(mar = rep(0.5, 4), oma = c(4.5, 0.5, 0, 4.5))

# Run through call types 
for(j in 1:3){

  # Plot ind model
  load( c(
    'ANALYSIS/RESULTS/01_compare_call_types/model_result_dtw_contact.RData',
    'ANALYSIS/RESULTS/01_compare_call_types/model_result_dtw_tja.RData',
    'ANALYSIS/RESULTS/01_compare_call_types/model_result_dtw_trruup.RData'
  )[j] )
  plot(NULL, xlim = c(-0.2, 0.6), ylim = c(0, 20), main = '',
       xlab = '', ylab = '', xaxt = 'n', yaxt = 'n')
  abline(v = 0, lty = 2, lwd = 3, col = 'grey')
  if(j == 3){
    axis(1, c(0, 0.5))
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
  plot(NULL, xlim = c(-7, 7), ylim = c(0.15, 0.7), main = '',
       xlab = '',
       ylab = '', xaxt = 'n', yaxt = 'n')
  axis(4, c(0.2, 0.4, 0.6))
  if(j == 3) mtext('acoustic distance', 4, 3)
  if(j == 3){
    mtext(' time [s]         time [days]',
          1, 3)
    axis(1, c(-7, -4, -1, 1, 4, 7), c(0.01, 0.32, 10, 0, 15, 30))
  }
  lines(c(0, 0), c(0.15, 0.7), lwd = 2)

  load( c(
    'ANALYSIS/RESULTS/02_time_effect/model_result_time_dtw_contact_post.RData',
    'ANALYSIS/RESULTS/02_time_effect/model_result_time_dtw_tja_post.RData',
    'ANALYSIS/RESULTS/02_time_effect/model_result_time_dtw_trruup_post.RData'
  )[j] )
  for(i in sample(1:length(post$a_bar), 20))
    lines(c(-7, -1), post[['a_bar']][i] + c(-2, 1) * post[['b_bar']][i],
          col = 4, lwd = 5, lty = 1)

  load( c(
    'ANALYSIS/RESULTS/02_time_effect/model_results_date_dtw_contact_post.RData',
    'ANALYSIS/RESULTS/02_time_effect/model_results_date_dtw_tja_post.RData',
    'ANALYSIS/RESULTS/02_time_effect/model_results_date_dtw_trruup_post.RData'
  )[j] )
  for(i in sample(1:length(post$a_bar), 20))
    lines(c(1, 7), post[['a_bar']][i] + c(0, 1) * post[['b_bar']][i],
          col = 3, lwd = 5, lty = 1)

} # end i loop

# Save PDF
dev.off()

# Open PDF mf4c ----
pdf(path_pdf_composite_figure_mfcccc, 4, 6)

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
    'ANALYSIS/RESULTS/01_compare_call_types/model_result_mfcccc_contact.RData',
    'ANALYSIS/RESULTS/01_compare_call_types/model_result_mfcccc_tja.RData',
    'ANALYSIS/RESULTS/01_compare_call_types/model_result_mfcccc_trruup.RData',
    'ANALYSIS/RESULTS/01_compare_call_types/model_result_mfcccc_alarm.RData',
    'ANALYSIS/RESULTS/01_compare_call_types/model_result_mfcccc_growl.RData'
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
  plot(NULL, xlim = c(-7, 7), ylim = c(0.0, 0.5), main = '',
       xlab = '',
       ylab = '', xaxt = 'n', yaxt = 'n')
  axis(4, c(0.1, 0.3, 0.5))
  if(j == 3) mtext('acoustic distance', 4, 3)
  if(j == 5){
    mtext(' time [s]         time [days]',
          1, 3)
    axis(1, c(-7, -4, -1, 1, 4, 7), c(0.01, 0.32, 10, 0, 15, 30))
  }
  lines(c(0, 0), c(0.0, 0.5), lwd = 2)

  load( c(
    'ANALYSIS/RESULTS/02_time_effect/model_result_time_mfcccc_contact_post.RData',
    'ANALYSIS/RESULTS/02_time_effect/model_result_time_mfcccc_tja_post.RData',
    'ANALYSIS/RESULTS/02_time_effect/model_result_time_mfcccc_trruup_post.RData',
    'ANALYSIS/RESULTS/02_time_effect/model_result_time_mfcccc_alarm_post.RData',
    'ANALYSIS/RESULTS/02_time_effect/model_result_time_mfcccc_growl_post.RData'
  )[j] )
  for(i in sample(1:length(post$a_bar), 20))
    lines(c(-7, -1), post[['a_bar']][i] + c(-2, 1) * post[['b_bar']][i],
          col = 4, lwd = 5, lty = 1)

  load( c(
    'ANALYSIS/RESULTS/02_time_effect/model_results_date_mfcccc_contact_post.RData',
    'ANALYSIS/RESULTS/02_time_effect/model_results_date_mfcccc_tja_post.RData',
    'ANALYSIS/RESULTS/02_time_effect/model_results_date_mfcccc_trruup_post.RData',
    'ANALYSIS/RESULTS/02_time_effect/model_results_date_mfcccc_alarm_post.RData',
    'ANALYSIS/RESULTS/02_time_effect/model_results_date_mfcccc_growl_post.RData'
  )[j] )
  for(i in sample(1:length(post$a_bar), 20))
    lines(c(1, 7), post[['a_bar']][i] + c(0, 1) * post[['b_bar']][i],
          col = 3, lwd = 5, lty = 1)

} # end i loop

# Save PDF
dev.off()

# Open PDF specan ----
pdf(path_pdf_composite_figure_specan, 4, 6)

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
    'ANALYSIS/RESULTS/01_compare_call_types/model_result_specan_contact.RData',
    'ANALYSIS/RESULTS/01_compare_call_types/model_result_specan_tja.RData',
    'ANALYSIS/RESULTS/01_compare_call_types/model_result_specan_trruup.RData',
    'ANALYSIS/RESULTS/01_compare_call_types/model_result_specan_alarm.RData',
    'ANALYSIS/RESULTS/01_compare_call_types/model_result_specan_growl.RData'
  )[j] )
  plot(NULL, xlim = c(-0.05, 0.15), ylim = c(0, 100), main = '', 
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
  plot(NULL, xlim = c(-7, 7), ylim = c(0.0, 0.6), main = '', 
       xlab = '', 
       ylab = '', xaxt = 'n', yaxt = 'n')
  axis(4, c(0.1, 0.3, 0.5))
  if(j == 3) mtext('acoustic distance', 4, 3)
  if(j == 5){
    mtext(' time [s]         time [days]',
          1, 3)
    axis(1, c(-7, -4, -1, 1, 4, 7), c(0.01, 0.32, 10, 0, 15, 30))
  }
  lines(c(0, 0), c(0.0, 0.6), lwd = 2)  
  
  load( c(
    'ANALYSIS/RESULTS/02_time_effect/model_result_time_specan_contact_post.RData',
    'ANALYSIS/RESULTS/02_time_effect/model_result_time_specan_tja_post.RData',
    'ANALYSIS/RESULTS/02_time_effect/model_result_time_specan_trruup_post.RData',
    'ANALYSIS/RESULTS/02_time_effect/model_result_time_specan_alarm_post.RData',
    'ANALYSIS/RESULTS/02_time_effect/model_result_time_specan_growl_post.RData'
  )[j] )
  for(i in sample(1:length(post$a_bar), 20)) 
    lines(c(-7, -1), post[['a_bar']][i] + c(-2, 1) * post[['b_bar']][i], 
          col = 4, lwd = 5, lty = 1)
  
  load( c(
    'ANALYSIS/RESULTS/02_time_effect/model_results_date_specan_contact_post.RData',
    'ANALYSIS/RESULTS/02_time_effect/model_results_date_specan_tja_post.RData',
    'ANALYSIS/RESULTS/02_time_effect/model_results_date_specan_trruup_post.RData',
    'ANALYSIS/RESULTS/02_time_effect/model_results_date_specan_alarm_post.RData',
    'ANALYSIS/RESULTS/02_time_effect/model_results_date_specan_growl_post.RData'
  )[j] )
  for(i in sample(1:length(post$a_bar), 20)) 
    lines(c(1, 7), post[['a_bar']][i] + c(0, 1) * post[['b_bar']][i], 
          col = 3, lwd = 5, lty = 1)
  
} # end i loop

# Save PDF
dev.off()

