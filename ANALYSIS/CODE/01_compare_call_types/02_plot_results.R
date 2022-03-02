# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 12-10-2021
# Date last modified: 02-03-2022
# Author: Simeon Q. Smeele
# Description: Plotting model results per method.  
# This version includes not all call types, but more than before. 
# This version works for the 2021 data and the cmdstanr model output. 
# This version plots a page per year. 
# This version includes code to plot some other parameters to test. 
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
call_types = c('contact', 'loud_contact', 'short_contact', 'trruup', 'tja', 
               'alarm', 'growl', 'growl_low', 'kaw', 'frill')

# Plot beta parameter per call type
{
  pdf(path_pdf_ind_results, 19, 9)
  par(mfrow = c(4, 11), oma = c(2, 0, 2, 0), mgp = c(1, 0.75, 0))
  
  for(year in c(20, 21)){
    write.title('DTW')
    plot.model(all_models_out$dtw[[sprintf('models_out_%s', year)]]$contact, yaxt = 'l')
    mtext('contact', 3, 1, font = 2)
    mtext('density', 2, 2, cex = 0.75)
    if(year == 20) plot.new() else 
      plot.model(all_models_out$dtw[[sprintf('models_out_%s', year)]]$loud_contact)
    mtext('loud contact', 3, 1, font = 2)
    plot.model(all_models_out$dtw[[sprintf('models_out_%s', year)]]$short_contact)
    mtext('short contact', 3, 1, font = 2)
    plot.model(all_models_out$dtw[[sprintf('models_out_%s', year)]]$trruup)
    mtext('trruup', 3, 1, font = 2)
    plot.model(all_models_out$dtw[[sprintf('models_out_%s', year)]]$tja)
    mtext('tja', 3, 1, font = 2)
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
    plot.model(all_models_out$spcc[[sprintf('models_out_%s', year)]]$contact, yaxt = 'l')
    mtext('density', 2, 2, cex = 0.75)
    if(year == 20) plot.new() else
      plot.model(all_models_out$spcc[[sprintf('models_out_%s', year)]]$loud_contact)
    plot.model(all_models_out$spcc[[sprintf('models_out_%s', year)]]$short_contact)
    plot.model(all_models_out$spcc[[sprintf('models_out_%s', year)]]$trruup)
    plot.model(all_models_out$spcc[[sprintf('models_out_%s', year)]]$tja)
    plot.model(all_models_out$spcc[[sprintf('models_out_%s', year)]]$alarm)
    plot.model(all_models_out$spcc[[sprintf('models_out_%s', year)]]$growl)
    plot.model(all_models_out$spcc[[sprintf('models_out_%s', year)]]$growl_low)
    plot.model(all_models_out$spcc[[sprintf('models_out_%s', year)]]$kaw)
    plot.model(all_models_out$spcc[[sprintf('models_out_%s', year)]]$frill)
    
    write.title('SPECAN')
    plot.model(all_models_out$specan[[sprintf('models_out_%s', year)]]$contact, yaxt = 'l')
    mtext('density', 2, 2, cex = 0.75)
    if(year == 20) plot.new() else
      plot.model(all_models_out$specan[[sprintf('models_out_%s', year)]]$loud_contact)
    plot.model(all_models_out$specan[[sprintf('models_out_%s', year)]]$short_contact)
    plot.model(all_models_out$specan[[sprintf('models_out_%s', year)]]$trruup)
    plot.model(all_models_out$specan[[sprintf('models_out_%s', year)]]$tja)
    plot.model(all_models_out$specan[[sprintf('models_out_%s', year)]]$alarm)
    plot.model(all_models_out$specan[[sprintf('models_out_%s', year)]]$growl)
    plot.model(all_models_out$specan[[sprintf('models_out_%s', year)]]$growl_low)
    plot.model(all_models_out$specan[[sprintf('models_out_%s', year)]]$kaw)
    plot.model(all_models_out$specan[[sprintf('models_out_%s', year)]]$frill)
    
    write.title('MFCC')
    plot.model(all_models_out$mfcc[[sprintf('models_out_%s', year)]]$contact, yaxt = 'l', xaxt = 'l')
    mtext('density', 2, 2, cex = 0.75)
    mtext('beta', 1, 2, cex = 0.75)
    if(year == 20) plot.new() else {
      plot.model(all_models_out$mfcc[[sprintf('models_out_%s', year)]]$loud_contact, xaxt = 'l')
      mtext('beta', 1, 2, cex = 0.75)
    }
    plot.model(all_models_out$mfcc[[sprintf('models_out_%s', year)]]$short_contact, xaxt = 'l')
    mtext('beta', 1, 2, cex = 0.75)
    plot.model(all_models_out$mfcc[[sprintf('models_out_%s', year)]]$trruup, xaxt = 'l')
    mtext('beta', 1, 2, cex = 0.75)
    plot.model(all_models_out$mfcc[[sprintf('models_out_%s', year)]]$tja, xaxt = 'l')
    mtext('beta', 1, 2, cex = 0.75)
    plot.model(all_models_out$mfcc[[sprintf('models_out_%s', year)]]$alarm, xaxt = 'l')
    mtext('beta', 1, 2, cex = 0.75)
    plot.model(all_models_out$mfcc[[sprintf('models_out_%s', year)]]$growl, xaxt = 'l')
    mtext('beta', 1, 2, cex = 0.75)
    plot.model(all_models_out$mfcc[[sprintf('models_out_%s', year)]]$growl_low, xaxt = 'l')
    mtext('beta', 1, 2, cex = 0.75)
    plot.model(all_models_out$mfcc[[sprintf('models_out_%s', year)]]$kaw, xaxt = 'l')
    mtext('beta', 1, 2, cex = 0.75)
    plot.model(all_models_out$mfcc[[sprintf('models_out_%s', year)]]$frill, xaxt = 'l')
    mtext('beta', 1, 2, cex = 0.75)
  }
  
  dev.off()
}

# Plot other parameters
pdf(path_pdf_model_parameters)
post = all_models_out$dtw$contact
post_flat = apply(post, 3, rbind)
post_b_ind_pair = post_flat[,str_detect(colnames(post_flat), 'b_ind_pair')]
dev.off()

message('Done.')