# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 12-10-2021
# Date last modified: 13-10-2021
# Author: Simeon Q. Smeele
# Description: Plotting model results per method.  
# This version includes all call types. 
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
path_models_iso_contact = 'ANALYSIS/RESULTS/00_compare_methods/models.RData'
path_models_spcc = 'ANALYSIS/RESULTS/spcc/models'
path_models_mfcc = 'ANALYSIS/RESULTS/mfcc/models'
path_functions = 'ANALYSIS/CODE/functions'
path_pdf = 'ANALYSIS/RESULTS/00_compare_methods/model results.pdf'

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Load data
load(path_models_iso_contact)
models_spcc = list.files(path_models_spcc, recursive = T, full.names = T)
models_mfcc = list.files(path_models_mfcc, recursive = T, full.names = T)

# Functions to plot
plot.model = function(model, main = '', yaxt = 'n', xaxt = 'n'){
  post = extract.samples(model)
  plot(NULL, xlim = c(-2, 2), ylim = c(0, 10), main = str_replace(main, '_', ' '), 
       xlab = '', ylab = '', xaxt = xaxt, yaxt = yaxt)
  abline(v = 0, col = alpha(1, 0.5), lwd = 5, lty = 2)
  post$b_bar_rec %>% density %>% lines(col = alpha(4, 1), lwd = 5, lty = 1)
  post$b_bar_ind %>% density %>% lines(col = alpha(3, 1), lwd = 5, lty = 1)
  text(-2, 9, sprintf('N = %s', ncol(post$z_call)), adj = 0)
  # text(c(-2, -2), c(1, 2), c('beta individual', 'beta recording'), col = c(2, 4), adj = 0)
}
write.title = function(label){
  par(mar = c(1, 3, 2, 2))
  plot(NULL, xlim = c(-1, 1), ylim = c(-1, 1), 
       xlab = '', ylab = '', xaxt = 'n', yaxt = 'n', bty = 'n')
  mtext('density', 4, cex = 0.75)
  text(0, 0, label, font = 2, cex = 1.25)
  par(mar = c(2, 1, 2, 0.1))
}

# Order call types
call_types = c('contact', 'short_contact', 'alarm', 'growl', 'trruup', 'tja', 'tjup')

# Plot beta parameter per call type
pdf(path_pdf, 15, 8)
par(mfrow = c(4, 9))
write.title('SPCC')
plot.model(model_spcc, main = 'isolated contact', yaxt = 'l')
for(type in call_types){
  path_model = models_spcc[str_detect(models_spcc, type)][1] # fix for contact
  load(path_model)
  plot.model(model, type)
}
write.title('MFCC')
plot.model(model_mfcc, main = 'isolated contact', yaxt = 'l')
for(type in call_types){
  path_model = models_mfcc[str_detect(models_mfcc, type)][1] # fix for contact
  load(path_model)
  plot.model(model, type, xaxt = 'l')
}
write.title('DTW')
plot.model(model_dtw, main = 'isolated contact', yaxt = 'l', xaxt = 'l')
for(i in 1:7){
  plot(NULL, xlim = c(-1, 1), ylim = c(-1, 1), 
       xlab = '', ylab = '', xaxt = 'n', yaxt = 'n', bty = 'n')
  mtext('beta', 3, cex = 0.75)
}
plot(NULL, xlim = c(-1, 1), ylim = c(-1, 1), 
     xlab = '', ylab = '', xaxt = 'n', yaxt = 'n', bty = 'n')
plot(NULL, xlim = c(-1, 1), ylim = c(-1, 1), 
     xlab = '', ylab = '', xaxt = 'n', yaxt = 'n', bty = 'n')
mtext('beta', 3, cex = 0.75)
dev.off()
