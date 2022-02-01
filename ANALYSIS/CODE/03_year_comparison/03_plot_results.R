# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 30-01-2022
# Date last modified: 01-02-2022
# Author: Simeon Q. Smeele
# Description: Plotting model results per method.
# This version includes all methods and call types. 
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
load(path_year_model_results)
load(path_data_sets_year)

# Functions to plot
plot.model = function(post, yaxt = 'n', xaxt = 'n'){
  post_flat = apply(post, 3, rbind)
  plot(NULL, xlim = c(-0.5, 1.5), ylim = c(0, 10), xaxt = xaxt, yaxt = yaxt,
       xlab = '', ylab = '', main = '')
  abline(v = 0, col = alpha(1, 0.5), lwd = 5, lty = 2)
  post_flat[,'b_bar'] %>% density %>% lines(col = alpha(6, 1), lwd = 5, lty = 1)
  text(1.5, 9, sprintf('N = %s', length(which(str_detect(colnames(post_flat), 'z_call')))), adj = 1)}
write.title = function(label){
  par(mar = c(2, 3, 1, 2))
  plot(NULL, xlim = c(-1, 1), ylim = c(-1, 1), 
       xlab = '', ylab = '', xaxt = 'n', yaxt = 'n', bty = 'n')
  text(0, 0, label, font = 2, cex = 1.25)
  par(mar = c(2, 1, 1, 0.1))
}

# Order call types
call_types = c('contact', 'short_contact', 'trruup', 'tja', 'alarm', 'growl', 'growl_low')

# Plot beta parameter per call type
{
  pdf(path_pdf_year_results, 13, 8)
  par(mfrow = c(4, 8), oma = c(2, 0, 2, 0), mgp = c(1, 0.75, 0))
  
  write.title('DTW')
  plot.model(all_models_out_year$dtw$contact, yaxt = 'l')
  mtext('contact', 3, 1, font = 2)
  mtext('density', 2, 2, cex = 0.75)
  plot.model(all_models_out_year$dtw$short_contact)
  mtext('short contact', 3, 1, font = 2)
  plot.model(all_models_out_year$dtw$trruup)
  mtext('trruup', 3, 1, font = 2)
  plot.model(all_models_out_year$dtw$tja)
  mtext('tja', 3, 1, font = 2)
  plot.new()
  mtext('alarm', 3, 1, font = 2)
  plot.new()
  mtext('growl', 3, 1, font = 2)
  plot.new()
  mtext('growl low', 3, 1, font = 2)
  
  write.title('SPCC')
  plot.model(all_models_out_year$spcc$contact, yaxt = 'l')
  mtext('density', 2, 2, cex = 0.75)
  plot.model(all_models_out_year$spcc$short_contact)
  plot.model(all_models_out_year$spcc$trruup)
  plot.model(all_models_out_year$spcc$tja)
  plot.model(all_models_out_year$spcc$alarm)
  plot.model(all_models_out_year$spcc$growl)
  plot.model(all_models_out_year$spcc$growl_low)
  
  write.title('SPECAN')
  plot.model(all_models_out_year$specan$contact, yaxt = 'l')
  mtext('density', 2, 2, cex = 0.75)
  plot.model(all_models_out_year$specan$short_contact)
  plot.model(all_models_out_year$specan$trruup)
  plot.model(all_models_out_year$specan$tja)
  plot.model(all_models_out_year$specan$alarm)
  plot.model(all_models_out_year$specan$growl)
  plot.model(all_models_out_year$specan$growl_low)
  
  write.title('MFCC')
  plot.model(all_models_out_year$mfcc$contact, yaxt = 'l', xaxt = 'l')
  mtext('density', 2, 2, cex = 0.75)
  mtext('beta', 1, 2, cex = 0.75)
  plot.model(all_models_out_year$mfcc$short_contact, xaxt = 'l')
  mtext('beta', 1, 2, cex = 0.75)
  plot.model(all_models_out_year$mfcc$trruup, xaxt = 'l')
  mtext('beta', 1, 2, cex = 0.75)
  plot.model(all_models_out_year$mfcc$tja, xaxt = 'l')
  mtext('beta', 1, 2, cex = 0.75)
  plot.model(all_models_out_year$mfcc$alarm, xaxt = 'l')
  mtext('beta', 1, 2, cex = 0.75)
  plot.model(all_models_out_year$mfcc$growl, xaxt = 'l')
  mtext('beta', 1, 2, cex = 0.75)
  plot.model(all_models_out_year$mfcc$growl_low, xaxt = 'l')
  mtext('beta', 1, 2, cex = 0.75)
  
  dev.off()
}

message('Done.')
