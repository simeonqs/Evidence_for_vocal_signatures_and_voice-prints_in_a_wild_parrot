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
path_models = 'ANALYSIS/RESULTS/01_time_effect/models.RData'
path_data = 'ANALYSIS/RESULTS/01_time_effect/data_Sets.RData'
path_functions = 'ANALYSIS/CODE/functions'
path_pdf = 'ANALYSIS/RESULTS/01_time_effect/model results.pdf'

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Load data
load(path_models)
load(path_data)

# Functions to plot
plot.model = function(model, dat, xaxt = 'n'){
  post = extract.samples(model)
  plot(dat$time, dat$d, pch = 16, col = alpha('grey', 0.5),
       xlim = c(0, 0.2), ylim = c(-1.5, 2.5),
       xlab = '', ylab = '', xaxt = xaxt, yaxt = 'n')
  lines(c(0, 0.2), mean(post$a_bar) + c(0, 0.2) * mean(post$b_bar), col = alpha(3, 1), lwd = 5, lty = 1)
  text(1, 1, sprintf('N = %s', ncol(post$z_call)), adj = 1)
  # text(c(-2, -2), c(1, 2), c('beta individual', 'beta recording'), col = c(2, 4), adj = 0)
}
write.title = function(label){
  par(mar = c(1, 3, 2, 2))
  plot(NULL, xlim = c(-1, 1), ylim = c(-1, 1), 
       xlab = '', ylab = '', xaxt = 'n', yaxt = 'n', bty = 'n')
  mtext('distance', 4, cex = 0.75)
  text(0, 0, label, font = 2, cex = 1.25)
  par(mar = c(2, 1, 1, 0.1))
}

# Order call types
call_types = c('contact', 'short_contact', 'alarm', 'growl', 'trruup', 'tja', 'tjup')

# Plot beta parameter per call type
pdf(path_pdf, 15, 5.5)
par(mfrow = c(2, 8), oma = c(2, 0, 2, 1))
write.title('SPCC')
for(type in call_types){
  i = which(str_detect(names(data_sets_mfcc), type))[1]
  plot.model(models_mfcc[[i]], data_sets_mfcc[[i]])
  mtext(type, 3, 1, font = 2)
}
write.title('MFCC')
for(type in call_types){
  i = which(str_detect(names(data_sets_spcc), type))[1]
  plot.model(models_spcc[[i]], data_sets_spcc[[i]], xaxt = 'l')
}
dev.off()
