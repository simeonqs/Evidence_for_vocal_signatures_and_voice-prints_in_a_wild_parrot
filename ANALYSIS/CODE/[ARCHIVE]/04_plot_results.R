# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 12-10-2021
# Date last modified: 08-03-2022
# Author: Simeon Q. Smeele
# Description: Plotting model results per method.  
# This version includes all call types. 
# This version also includes the date results. 
# This version is updated for the 2021 data and new structure. 
# This version switches to acoustic similarity rather than distance. 
# This version also includes the 2020 data. 
# This version switches back to proper posterior format. 
# This version runs on combined data. 
# source('ANALYSIS/CODE/03_time_effect/04_plot_results.R')
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
load(path_time_model_results)
load(path_data_sets_time)
load(path_date_model_results)
load(path_data_sets_date)

# Functions to plot
plot.model.time = function(post, dat){
  points((dat$time + 2) * 7.5, -dat$d, pch = 16, col = alpha('purple', 0.1))
  shade(-apply(sapply(1:length(post[['a_bar']]), 
                      function(i) 
                        post[['a_bar']][i] + c(-2, 2) * post[['b_bar']][i]), 1, PI),         
        (c(-2, 2) + 2) * 7.5, col = alpha('purple', 0.2))
  lines((c(-2, 2) + 2) * 7.5, -(mean(post[['a_bar']]) + c(-2, 2) * mean(post[['b_bar']])), 
        col = alpha('purple', 1), lwd = 5, lty = 1)
}
plot.model.dates = function(post, dat){
  shade(-apply(sapply(1:length(post[['a_bar']]), 
                      function(i) post[['a_bar']][i] + c(0, 30) * post[['b_bar']][i]), 1, PI), 
        c(0, 30), col = alpha('darkorange', 0.1))
  lines(c(0, 30), -(mean(post[['a_bar']]) + c(0, 30) * mean(post[['b_bar']])), 
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
call_types = c('contact', 'loud_contact', 'short_contact', 'trruup', 'tja', 'tjup', 'alarm', 'growl', 'growl_low')

# Plot beta parameter per call type
{
  pdf(path_pdf_time_results, 18, 9)
  par(mfrow = c(4, 10), oma = c(2, 0, 2, 1), mgp = c(1, 0.75, 0))
  
  write.title('DTW')
  for(type in c('contact', 'loud_contact', 'short_contact', 'trruup', 'tja', 'tjup')){
    plot(data_sets_date$dtw[[type]]$date, -data_sets_date$dtw[[type]]$d, 
         pch = 16, col = alpha('darkorange', 0.1),
         xlim = c(0, 25), ylim = c(-3, 3),
         xlab = '', ylab = '', xaxt = 'n', yaxt = 'n')
    plot.model.time(all_models_out_time$dtw[[type]]$post, 
                    data_sets_time$dtw[[type]])
    plot.model.dates(all_models_out_date$dtw[[type]]$post, 
                     data_sets_date$dtw[[type]])
    if(type == call_types[1]){
      axis(2)
      mtext('accoustic similarity', 2, 2, cex = 0.75)
    } 
    mtext(str_replace(type, '_', ' '), 3, 1, font = 2)
  }
  plot.new()
  mtext(str_replace(call_types[7], '_', ' '), 3, 1, font = 2)
  plot.new()
  mtext(str_replace(call_types[8], '_', ' '), 3, 1, font = 2)
  plot.new()
  mtext(str_replace(call_types[9], '_', ' '), 3, 1, font = 2)
  
  write.title('SPCC')
  for(type in call_types){
    plot(data_sets_date$spcc[[type]]$date, -data_sets_date$spcc[[type]]$d, 
         pch = 16, col = alpha('darkorange', 0.1),
         xlim = c(0, 25), ylim = c(-2, 2),
         xlab = '', ylab = '', xaxt = 'n', yaxt = 'n')
    plot.model.time(all_models_out_time$spcc[[type]]$post, 
                    data_sets_time$spcc[[type]])
    plot.model.dates(all_models_out_date$spcc[[type]]$post, 
                     data_sets_date$spcc[[type]])
    if(type == call_types[1]){
      axis(2)
      mtext('accoustic similarity', 2, 2, cex = 0.75)
    } 
    axis(1, (seq(-2, 2, 1) + 2) * 7.5, 10^seq(-2, 2, 1))
    axis(3, seq(0, 30, 5), seq(0, 30, 5))
    mtext('difference [minutes]', 1, 2, cex = 0.75)
    mtext('difference [days]', 3, 2, cex = 0.75)
  }
  
  write.title('SPECAN')
  for(type in call_types){
    plot(data_sets_date$specan[[type]]$date, -data_sets_date$specan[[type]]$d, 
         pch = 16, col = alpha('darkorange', 0.1),
         xlim = c(0, 25), ylim = c(-2, 2),
         xlab = '', ylab = '', xaxt = 'n', yaxt = 'n')
    plot.model.time(all_models_out_time$specan[[type]]$post, 
                    data_sets_time$specan[[type]])
    plot.model.dates(all_models_out_date$specan[[type]]$post, 
                     data_sets_date$specan[[type]])
    if(type == call_types[1]){
      axis(2)
      mtext('accoustic similarity', 2, 2, cex = 0.75)
    } 
  }
  
  write.title('MFCC')
  for(type in call_types){
    plot(data_sets_date$mfcc[[type]]$date, -data_sets_date$mfcc[[type]]$d, 
         pch = 16, col = alpha('darkorange', 0.1),
         xlim = c(0, 25), ylim = c(-2, 2),
         xlab = '', ylab = '', xaxt = 'n', yaxt = 'n', main = '')
    plot.model.time(all_models_out_time$mfcc[[type]]$post, 
                    data_sets_time$mfcc[[type]])
    plot.model.dates(all_models_out_date$mfcc[[type]]$post, 
                     data_sets_date$mfcc[[type]])
    if(type == call_types[1]){
      axis(2)
      mtext('accoustic similarity', 2, 2, cex = 0.75)
    } 
    axis(1, (seq(-2, 2, 1) + 2) * 7.5, 10^seq(-2, 2, 1))
    axis(3, seq(0, 30, 5), seq(0, 30, 5))
    mtext('difference [minutes]', 1, 2, cex = 0.75)
    mtext('difference [days]', 3, 2, cex = 0.75)
  }
  
  dev.off()
}

