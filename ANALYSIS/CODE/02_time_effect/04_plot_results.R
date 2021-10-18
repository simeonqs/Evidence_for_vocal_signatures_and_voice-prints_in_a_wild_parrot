# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 12-10-2021
# Date last modified: 18-10-2021
# Author: Simeon Q. Smeele
# Description: Plotting model results per method.  
# This version includes all call types. 
# This version also includes the date results. 
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
path_models_time = 'ANALYSIS/RESULTS/01_time_effect/models_time.RData'
path_data_time = 'ANALYSIS/RESULTS/01_time_effect/data_sets_time.RData'
path_models_dates = 'ANALYSIS/RESULTS/01_time_effect/models_dates.RData'
path_data_dates = 'ANALYSIS/RESULTS/01_time_effect/data_sets_dates.RData'
path_functions = 'ANALYSIS/CODE/functions'
path_pdf = 'ANALYSIS/RESULTS/01_time_effect/model results.pdf'

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Load data
load(path_models_time)
load(path_data_time)
load(path_models_dates)
load(path_data_dates)

# Functions to plot
plot.model.time = function(model, dat){
  post = extract.samples(model)
  points(dat$time, dat$d, pch = 16, col = alpha('grey', 0.2))
  shade(apply(sapply(seq_along(post$a_bar), function(i) post$a_bar[i] + c(0, 0.2) * post$b_bar[i]), 1, PI), 
        c(0, 0.2), col = alpha('purple', 0.2))
  lines(c(0, 0.2), mean(post$a_bar) + c(0, 0.2) * mean(post$b_bar), 
        col = alpha('purple', 1), lwd = 5, lty = 1)
}
plot.model.dates = function(model, dat){
  post = extract.samples(model)
  shade(apply(sapply(seq_along(post$a_bar), function(i) post$a_bar[i] + c(0, 1) * post$b_bar[i]), 1, PI), 
        c(0, 0.2), col = alpha('darkorange', 0.2))
  lines(c(0, 0.2), mean(post$a_bar) + c(0, 1) * mean(post$b_bar), 
        col = alpha('darkorange', 1), lwd = 5, lty = 1)
}
write.title = function(label){
  par(mar = c(1, 3, 2, 2))
  plot(NULL, xlim = c(-1, 1), ylim = c(-1, 1), 
       xlab = '', ylab = '', xaxt = 'n', yaxt = 'n', bty = 'n')
  text(0, 0, label, font = 2, cex = 1.25)
  par(mar = c(2, 1, 2, 0.1))
}

# Order call types
call_types = c('contact', 'short_contact', 'alarm', 'growl', 'trruup', 'tja', 'tjup')

# Plot beta parameter per call type
pdf(path_pdf, 15, 5.5)
par(mfrow = c(2, 8), oma = c(2, 0, 2, 1), mgp = c(1, 0.75, 0))
write.title('SPCC')
for(type in call_types){
  i = which(str_detect(names(data_sets_spcc_time), type))[1]
  plot(data_sets_spcc_dates[[i]]$date/5, data_sets_spcc_dates[[i]]$d, pch = 16, col = alpha('black', 0.5),
       xlim = c(0, 0.2), ylim = c(-3, 3),
       xlab = '', ylab = '', xaxt = 'n', yaxt = 'n')
  plot.model.time(models_spcc_time[[i]], data_sets_spcc_time[[i]])
  plot.model.dates(models_spcc_dates[[i]], data_sets_spcc_dates[[i]])
  if(type == call_types[1]){
    axis(2)
    mtext('accoustic distance', 2, 2, cex = 0.75)
  } 
  mtext(str_replace(type, '_', ' '), 3, 1, font = 2)
}
write.title('MFCC')
for(type in call_types){
  i = which(str_detect(names(data_sets_mfcc_time), type))[1]
  plot(data_sets_mfcc_dates[[i]]$date/5, data_sets_mfcc_dates[[i]]$d, 
       pch = 16, col = alpha('black', 0.5),
       xlim = c(0, 0.2), ylim = c(-3, 3),
       xlab = '', ylab = '', xaxt = 'n', yaxt = 'n')
  plot.model.time(models_mfcc_time[[i]], data_sets_mfcc_time[[i]])
  if(type == call_types[1]){
    axis(2)
    mtext('accoustic distance', 2, 2, cex = 0.75)
  } 
  axis(1, seq(0, 0.2, 0.05), seq(0, 0.2, 0.05))
  axis(3, seq(0, 0.2, 0.05), seq(0, 0.2, 0.05)*5)
  mtext('difference [hours]', 1, 2, cex = 0.75)
  mtext('difference [months]', 3, 2, cex = 0.75)
  plot.model.dates(models_mfcc_dates[[i]], data_sets_mfcc_dates[[i]])
}
dev.off()
