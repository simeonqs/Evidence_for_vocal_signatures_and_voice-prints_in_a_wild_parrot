# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 12-10-2021
# Date last modified: 03-03-2022
# Author: Simeon Q. Smeele
# Description: Plotting model results per method.  
# This version includes not all call types, but more than before. 
# This version works for the 2021 data and the cmdstanr model output. 
# This version plots a page per year. 
# This version includes code to plot some other parameters to test. 
# This version used the stanr structure again. 
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
  
  for(year in c(20, 21)){
    write.title('DTW')
    plot.model(all_models_out$dtw[[sprintf('models_out_%s', year)]]$contact$post, yaxt = 'l')
    mtext('contact', 3, 1, font = 2)
    mtext('density', 2, 2, cex = 0.75)
    plot.model(all_models_out$dtw[[sprintf('models_out_%s', year)]]$loud_contact$post)
    mtext('loud contact', 3, 1, font = 2)
    plot.model(all_models_out$dtw[[sprintf('models_out_%s', year)]]$short_contact$post)
    mtext('short contact', 3, 1, font = 2)
    plot.model(all_models_out$dtw[[sprintf('models_out_%s', year)]]$trruup$post)
    mtext('trruup', 3, 1, font = 2)
    plot.model(all_models_out$dtw[[sprintf('models_out_%s', year)]]$tja$post)
    mtext('tja', 3, 1, font = 2)
    plot.model(all_models_out$dtw[[sprintf('models_out_%s', year)]]$tjup$post)
    mtext('tjup', 3, 1, font = 2)
    plot.model(all_models_out$dtw[[sprintf('models_out_%s', year)]]$other_tonal$post)
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
    plot.model(all_models_out$spcc[[sprintf('models_out_%s', year)]]$contact$post, yaxt = 'l')
    mtext('density', 2, 2, cex = 0.75)
    plot.model(all_models_out$spcc[[sprintf('models_out_%s', year)]]$loud_contact$post)
    plot.model(all_models_out$spcc[[sprintf('models_out_%s', year)]]$short_contact$post)
    plot.model(all_models_out$spcc[[sprintf('models_out_%s', year)]]$trruup$post)
    plot.model(all_models_out$spcc[[sprintf('models_out_%s', year)]]$tja$post)
    plot.model(all_models_out$spcc[[sprintf('models_out_%s', year)]]$tjup$post)
    plot.model(all_models_out$spcc[[sprintf('models_out_%s', year)]]$other_tonal$post)
    plot.model(all_models_out$spcc[[sprintf('models_out_%s', year)]]$alarm$post)
    plot.model(all_models_out$spcc[[sprintf('models_out_%s', year)]]$growl$post)
    plot.model(all_models_out$spcc[[sprintf('models_out_%s', year)]]$growl_low$post)
    plot.model(all_models_out$spcc[[sprintf('models_out_%s', year)]]$kaw$post)
    plot.model(all_models_out$spcc[[sprintf('models_out_%s', year)]]$frill$post)
    
    write.title('SPECAN')
    plot.model(all_models_out$specan[[sprintf('models_out_%s', year)]]$contact$post, yaxt = 'l')
    mtext('density', 2, 2, cex = 0.75)
    plot.model(all_models_out$specan[[sprintf('models_out_%s', year)]]$loud_contact$post)
    plot.model(all_models_out$specan[[sprintf('models_out_%s', year)]]$short_contact$post)
    plot.model(all_models_out$specan[[sprintf('models_out_%s', year)]]$trruup$post)
    plot.model(all_models_out$specan[[sprintf('models_out_%s', year)]]$tja$post)
    plot.model(all_models_out$specan[[sprintf('models_out_%s', year)]]$tjup$post)
    plot.model(all_models_out$specan[[sprintf('models_out_%s', year)]]$other_tonal$post)
    plot.model(all_models_out$specan[[sprintf('models_out_%s', year)]]$alarm$post)
    plot.model(all_models_out$specan[[sprintf('models_out_%s', year)]]$growl$post)
    plot.model(all_models_out$specan[[sprintf('models_out_%s', year)]]$growl_low$post)
    plot.model(all_models_out$specan[[sprintf('models_out_%s', year)]]$kaw$post)
    plot.model(all_models_out$specan[[sprintf('models_out_%s', year)]]$frill$post)
    
    write.title('MFCC')
    plot.model(all_models_out$mfcc[[sprintf('models_out_%s', year)]]$contact$post, yaxt = 'l', xaxt = 'l')
    mtext('density', 2, 2, cex = 0.75)
    mtext('beta', 1, 2, cex = 0.75)
    plot.model(all_models_out$mfcc[[sprintf('models_out_%s', year)]]$loud_contact$post, xaxt = 'l')
    mtext('beta', 1, 2, cex = 0.75)
    plot.model(all_models_out$mfcc[[sprintf('models_out_%s', year)]]$short_contact$post, xaxt = 'l')
    mtext('beta', 1, 2, cex = 0.75)
    plot.model(all_models_out$mfcc[[sprintf('models_out_%s', year)]]$trruup$post, xaxt = 'l')
    mtext('beta', 1, 2, cex = 0.75)
    plot.model(all_models_out$mfcc[[sprintf('models_out_%s', year)]]$tja$post, xaxt = 'l')
    mtext('beta', 1, 2, cex = 0.75)
    plot.model(all_models_out$mfcc[[sprintf('models_out_%s', year)]]$tjup$post, xaxt = 'l')
    mtext('beta', 1, 2, cex = 0.75)
    plot.model(all_models_out$mfcc[[sprintf('models_out_%s', year)]]$other_tonal$post, xaxt = 'l')
    mtext('beta', 1, 2, cex = 0.75)
    plot.model(all_models_out$mfcc[[sprintf('models_out_%s', year)]]$alarm$post, xaxt = 'l')
    mtext('beta', 1, 2, cex = 0.75)
    plot.model(all_models_out$mfcc[[sprintf('models_out_%s', year)]]$growl$post, xaxt = 'l')
    mtext('beta', 1, 2, cex = 0.75)
    plot.model(all_models_out$mfcc[[sprintf('models_out_%s', year)]]$growl_low$post, xaxt = 'l')
    mtext('beta', 1, 2, cex = 0.75)
    plot.model(all_models_out$mfcc[[sprintf('models_out_%s', year)]]$kaw$post, xaxt = 'l')
    mtext('beta', 1, 2, cex = 0.75)
    plot.model(all_models_out$mfcc[[sprintf('models_out_%s', year)]]$frill$post, xaxt = 'l')
    mtext('beta', 1, 2, cex = 0.75)
  }
  
  dev.off()
}

# # Plot other parameters
# pdf(path_pdf_model_parameters)
# post = all_models_out$dtw$contact
# post_flat = apply(post, 3, rbind)
# post_b_ind_pair = post_flat[,str_detect(colnames(post_flat), 'b_ind_pair')]
# dev.off()

message('Done.')
