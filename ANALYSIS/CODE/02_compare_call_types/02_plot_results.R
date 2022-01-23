# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 12-10-2021
# Date last modified: 20-01-2022
# Author: Simeon Q. Smeele
# Description: Plotting model results per method.  
# This version includes not all call types, but more than before. 
# This version works for the 2021 data and the cmdstanr model output. 
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
path_models = 'ANALYSIS/RESULTS/02_compare_call_types/all_models_out.RData'
path_functions = 'ANALYSIS/CODE/functions'
path_pdf = 'ANALYSIS/RESULTS/02_compare_call_types/model results.pdf'

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Load data
load(path_models)

# Functions to plot
plot.model = function(post, yaxt = 'n', xaxt = 'n'){
  post_flat = apply(post, 3, rbind)
  plot(NULL, xlim = c(-0.5, 1.5), ylim = c(0, 10), main = '', 
       xlab = '', ylab = '', xaxt = xaxt, yaxt = yaxt)
  abline(v = 0, col = alpha(1, 0.5), lwd = 5, lty = 2)
  post_flat[,'b_bar_rec'] %>% density %>% lines(col = alpha(4, 1), lwd = 5, lty = 1)
  post_flat[,'b_bar_ind'] %>% density %>% lines(col = alpha(3, 1), lwd = 5, lty = 1)
  text(1.5, 9, sprintf('N = %s', length(which(str_detect(colnames(post_flat), 'z_call')))), adj = 1)
}
write.title = function(label){
  par(mar = c(2, 3, 1, 2))
  plot(NULL, xlim = c(-1, 1), ylim = c(-1, 1), 
       xlab = '', ylab = '', xaxt = 'n', yaxt = 'n', bty = 'n')
  text(0, 0, label, font = 2, cex = 1.25)
  par(mar = c(2, 1, 1, 0.1))
}

# Order call types
call_types = c('contact', 'short_contact', 'alarm', 'growl', 'trruup', 'tja', 'tjup')

# Plot beta parameter per call type
{
  pdf(path_pdf, 13, 8)
  par(mfrow = c(4, 8), oma = c(2, 0, 2, 0), mgp = c(1, 0.75, 0))
  
  write.title('DTW')
  plot.model(all_models_out$dtw$contact, yaxt = 'l')
  mtext('contact', 3, 1, font = 2)
  mtext('density', 2, 2, cex = 0.75)
  plot.model(all_models_out$dtw$short_contact)
  mtext('short contact', 3, 1, font = 2)
  plot.model(all_models_out$dtw$trruup)
  mtext('trruup', 3, 1, font = 2)
  plot.model(all_models_out$dtw$tja)
  mtext('tja', 3, 1, font = 2)
  plot.model(all_models_out$dtw$tjup)
  mtext('tjup', 3, 1, font = 2)
  plot.new()
  mtext('alarm', 3, 1, font = 2)
  plot.new()
  mtext('growl', 3, 1, font = 2)
  
  write.title('SPCC')
  plot.model(all_models_out$spcc$contact, yaxt = 'l')
  mtext('density', 2, 2, cex = 0.75)
  plot.model(all_models_out$spcc$short_contact)
  plot.model(all_models_out$spcc$trruup)
  plot.model(all_models_out$spcc$tja)
  plot.model(all_models_out$spcc$tjup)
  plot.model(all_models_out$spcc$alarm)
  plot.model(all_models_out$spcc$growl)
  
  write.title('SPECAN')
  plot.model(all_models_out$specan$contact, yaxt = 'l')
  mtext('density', 2, 2, cex = 0.75)
  plot.model(all_models_out$specan$short_contact)
  plot.model(all_models_out$specan$trruup)
  plot.model(all_models_out$specan$tja)
  plot.model(all_models_out$specan$tjup)
  plot.model(all_models_out$specan$alarm)
  plot.model(all_models_out$specan$growl)
  
  write.title('MFCC')
  plot.model(all_models_out$mfcc$contact, yaxt = 'l', xaxt = 'l')
  mtext('density', 2, 2, cex = 0.75)
  mtext('beta', 1, 2, cex = 0.75)
  plot.model(all_models_out$mfcc$short_contact, xaxt = 'l')
  mtext('beta', 1, 2, cex = 0.75)
  plot.model(all_models_out$mfcc$trruup, xaxt = 'l')
  mtext('beta', 1, 2, cex = 0.75)
  plot.model(all_models_out$mfcc$tja, xaxt = 'l')
  mtext('beta', 1, 2, cex = 0.75)
  plot.model(all_models_out$mfcc$tjup, xaxt = 'l')
  mtext('beta', 1, 2, cex = 0.75)
  plot.model(all_models_out$mfcc$alarm, xaxt = 'l')
  mtext('beta', 1, 2, cex = 0.75)
  plot.model(all_models_out$mfcc$growl, xaxt = 'l')
  mtext('beta', 1, 2, cex = 0.75)
  
  dev.off()
}
