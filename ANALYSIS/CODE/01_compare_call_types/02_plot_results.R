# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 12-10-2021
# Date last modified: 10-03-2022
# Author: Simeon Q. Smeele
# Description: Plotting model results per method.  
# This version includes not all call types, but more than before. 
# This version works for the 2021 data and the cmdstanr model output. 
# This version plots a page per year. 
# This version includes code to plot some other parameters to test. 
# This version used the stanr structure again. 
# This version combines data from both years. 
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

# Load data
load(path_ind_model_results)

# Functions to plot
plot.model = function(post, yaxt = 'n', xaxt = 'n'){
  plot(NULL, xlim = c(-0.5, 1.5), ylim = c(0, 10), main = '', 
       xlab = '', ylab = '', xaxt = xaxt, yaxt = yaxt)
  abline(v = 0, col = alpha(1, 0.5), lwd = 5, lty = 2)
  post[['b_bar_rec']] %>% density %>% lines(col = alpha(4, 1), lwd = 5, lty = 1)
  post[['b_bar_ind']] %>% density %>% lines(col = alpha(3, 1), lwd = 5, lty = 1)
  text(1.25, 9, sprintf('N = %s', ncol(post$z_call), adj = 1))
}
write.title = function(label){
  par(mar = c(2, 3, 1, 2))
  plot(NULL, xlim = c(-1, 1), ylim = c(-1, 1), 
       xlab = '', ylab = '', xaxt = 'n', yaxt = 'n', bty = 'n')
  text(0, 0, label, font = 2, cex = 1.25)
  par(mar = c(2, 1, 1, 0.1))
}

# Order call types
call_types = c('contact', 'loud_contact', 'short_contact', 'trruup', 'tja', 'tjup', 'other_tonal',
               'alarm', 'growl', 'growl_low', 'kaw', 'frill')

# Plot beta parameter per call type
{
  pdf(path_pdf_ind_results, 23, 9)
  par(mfrow = c(4, 13), oma = c(2, 0, 2, 0), mgp = c(1, 0.75, 0))
  
  write.title('DTW')
  plot.model(all_models_out$dtw$contact$post, yaxt = 'l')
  mtext('contact', 3, 1, font = 2)
  mtext('density', 2, 2, cex = 0.75)
  plot.model(all_models_out$dtw$loud_contact$post)
  mtext('loud contact', 3, 1, font = 2)
  plot.model(all_models_out$dtw$short_contact$post)
  mtext('short contact', 3, 1, font = 2)
  plot.model(all_models_out$dtw$trruup$post)
  mtext('trruup', 3, 1, font = 2)
  plot.model(all_models_out$dtw$tja$post)
  mtext('tja', 3, 1, font = 2)
  plot.model(all_models_out$dtw$tjup$post)
  mtext('tjup', 3, 1, font = 2)
  plot.model(all_models_out$dtw$other_tonal$post)
  mtext('other_tonal', 3, 1, font = 2)
  plot.new()
  mtext('alarm', 3, 1, font = 2)
  plot.new()
  mtext('growl', 3, 1, font = 2)
  plot.new()
  mtext('growl low', 3, 1, font = 2)
  plot.new()
  mtext('kaw', 3, 1, font = 2)
  plot.new()
  mtext('frill', 3, 1, font = 2)
  
  write.title('SPCC')
  plot.model(all_models_out$spcc$contact$post, yaxt = 'l')
  mtext('density', 2, 2, cex = 0.75)
  plot.model(all_models_out$spcc$loud_contact$post)
  plot.model(all_models_out$spcc$short_contact$post)
  plot.model(all_models_out$spcc$trruup$post)
  plot.model(all_models_out$spcc$tja$post)
  plot.model(all_models_out$spcc$tjup$post)
  plot.model(all_models_out$spcc$other_tonal$post)
  plot.model(all_models_out$spcc$alarm$post)
  plot.model(all_models_out$spcc$growl$post)
  plot.model(all_models_out$spcc$growl_low$post)
  plot.model(all_models_out$spcc$kaw$post)
  plot.model(all_models_out$spcc$frill$post)
  
  write.title('SPECAN')
  plot.model(all_models_out$specan$contact$post, yaxt = 'l')
  mtext('density', 2, 2, cex = 0.75)
  plot.model(all_models_out$specan$loud_contact$post)
  plot.model(all_models_out$specan$short_contact$post)
  plot.model(all_models_out$specan$trruup$post)
  plot.model(all_models_out$specan$tja$post)
  plot.model(all_models_out$specan$tjup$post)
  plot.model(all_models_out$specan$other_tonal$post)
  plot.model(all_models_out$specan$alarm$post)
  plot.model(all_models_out$specan$growl$post)
  plot.model(all_models_out$specan$growl_low$post)
  plot.model(all_models_out$specan$kaw$post)
  plot.model(all_models_out$specan$frill$post)
  
  write.title('MFCC')
  plot.model(all_models_out$mfcc$contact$post, yaxt = 'l', xaxt = 'l')
  mtext('density', 2, 2, cex = 0.75)
  mtext('beta', 1, 2, cex = 0.75)
  plot.model(all_models_out$mfcc$loud_contact$post, xaxt = 'l')
  mtext('beta', 1, 2, cex = 0.75)
  plot.model(all_models_out$mfcc$short_contact$post, xaxt = 'l')
  mtext('beta', 1, 2, cex = 0.75)
  plot.model(all_models_out$mfcc$trruup$post, xaxt = 'l')
  mtext('beta', 1, 2, cex = 0.75)
  plot.model(all_models_out$mfcc$tja$post, xaxt = 'l')
  mtext('beta', 1, 2, cex = 0.75)
  plot.model(all_models_out$mfcc$tjup$post, xaxt = 'l')
  mtext('beta', 1, 2, cex = 0.75)
  plot.model(all_models_out$mfcc$other_tonal$post, xaxt = 'l')
  mtext('beta', 1, 2, cex = 0.75)
  plot.model(all_models_out$mfcc$alarm$post, xaxt = 'l')
  mtext('beta', 1, 2, cex = 0.75)
  plot.model(all_models_out$mfcc$growl$post, xaxt = 'l')
  mtext('beta', 1, 2, cex = 0.75)
  plot.model(all_models_out$mfcc$growl_low$post, xaxt = 'l')
  mtext('beta', 1, 2, cex = 0.75)
  plot.model(all_models_out$mfcc$kaw$post, xaxt = 'l')
  mtext('beta', 1, 2, cex = 0.75)
  plot.model(all_models_out$mfcc$frill$post, xaxt = 'l')
  mtext('beta', 1, 2, cex = 0.75)
  
  dev.off()
}

# # Plot other parameters
# pdf(path_pdf_model_parameters)
# post = all_models_out$dtw$contact
# post_flat = apply(post, 3, rbind)
# post_b_ind_pair = post_flat[,str_detect(colnames(post_flat), 'b_ind_pair')]
# dev.off()

message('Done.')
