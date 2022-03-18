# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 15-03-2022
# Date last modified: 15-03-2022
# Author: Simeon Q. Smeele
# Description: Plotting the final figures for the paper.
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
load(path_ind_model_results)

# The individual signal model
{
  # Functions to plot
  plot.model = function(post, yaxt = 'n', xaxt = 'n'){
    plot(NULL, xlim = c(-0.5, 1.5), ylim = c(0, 10), main = '', 
         xlab = '', ylab = '', xaxt = xaxt, yaxt = yaxt)
    abline(v = 0, col = alpha(1, 0.5), lwd = 5, lty = 2)
    post[['b_bar_rec']] %>% density %>% lines(col = alpha(4, 1), lwd = 5, lty = 1)
    post[['b_bar_ind']] %>% density %>% lines(col = alpha(3, 1), lwd = 5, lty = 1)
    text(1.4, 9, sprintf('N = %s', ncol(post$z_call)), adj = 1)
  }
  
  # Order call types
  call_types = c('contact', 'tja', 'trruup', 'alarm', 'growl')
  
  # Plot beta parameter per call type
  pdf(path_final_figure_ind, 10, 6)
  par(mfrow = c(3, 5), mar = c(1, 1, 0, 0), oma = c(3, 9, 3, 1), mgp = c(1, 0.75, 0))
  
  plot.model(all_models_out$dtw$contact$post, yaxt = 'l')
  mtext('contact', 3, 1, font = 2)
  mtext('density', 2, 2, cex = 0.75)
  mtext('DTW', 2, 7, font = 2, las = 2, adj = 0.5)
  plot.model(all_models_out$dtw$tja$post)
  mtext('tja', 3, 1, font = 2)
  plot.model(all_models_out$dtw$trruup$post)
  mtext('trruup', 3, 1, font = 2)
  plot.new()
  mtext('alarm', 3, 1, font = 2)
  plot.new()
  mtext('growl', 3, 1, font = 2)
  
  plot.model(all_models_out$spcc$contact$post, yaxt = 'l')
  mtext('density', 2, 2, cex = 0.75)
  mtext('SPCC', 2, 7, font = 2, las = 2, adj = 0.5)
  plot.model(all_models_out$spcc$tja$post)
  plot.model(all_models_out$spcc$trruup$post)
  plot.model(all_models_out$spcc$alarm$post)
  plot.model(all_models_out$spcc$growl$post)
  
  plot.model(all_models_out$specan$contact$post, yaxt = 'l', xaxt = 'l')
  mtext('density', 2, 2, cex = 0.75)
  mtext('beta', 1, 2, cex = 0.75)
  mtext('SPECAN', 2, 7, font = 2, las = 2, adj = 0.5)
  plot.model(all_models_out$specan$tja$post, xaxt = 'l')
  mtext('beta', 1, 2, cex = 0.75)
  plot.model(all_models_out$specan$trruup$post, xaxt = 'l')
  mtext('beta', 1, 2, cex = 0.75)
  plot.model(all_models_out$specan$alarm$post, xaxt = 'l')
  mtext('beta', 1, 2, cex = 0.75)
  plot.model(all_models_out$specan$growl$post, xaxt = 'l')
  mtext('beta', 1, 2, cex = 0.75)
  
  dev.off()
}


# The time figure
{
  # Functions to plot
  plot.model.time = function(post, dat){
    points((dat$time + 2) * 7.5, -dat$d, pch = 16, col = alpha('purple', 0))
    # shade(-apply(sapply(1:length(post[['a_bar']]), 
    #                     function(i) 
    #                       post[['a_bar']][i] + c(-2, 1.3) * post[['b_bar']][i]), 1, PI),         
    #       (c(-2, 1.3) + 2) * 7.5, col = alpha('purple', 0.2))
    for(i in sample(1:length(post$a_bar), 20)) 
      lines((c(-2, 1.3) + 2) * 7.5, -(post[['a_bar']][i] + c(-2, 1.3) * post[['b_bar']][i]), 
          col = alpha('purple', 0.3), lwd = 5, lty = 1)
  }
  plot.model.dates = function(post, dat){
    # shade(-apply(sapply(1:length(post[['a_bar']]), 
    #                     function(i) post[['a_bar']][i] + c(0, 25) * post[['b_bar']][i]), 1, PI), 
    #       c(0, 25), col = alpha('darkorange', 0.1))
    for(i in sample(1:length(post$a_bar), 20)) 
      lines(c(0, 25), -(post[['a_bar']][i] + c(0, 25) * post[['b_bar']][i]), 
          col = alpha('darkorange', 0.3), lwd = 5, lty = 1)
  }
  
  # Order call types
  call_types = c('contact', 'tja', 'trruup', 'alarm', 'growl')
  
  # Plot beta parameter per call type
  set.seed(1)
  pdf(path_final_figure_time, 10, 6)
  par(mfrow = c(3, 5), mar = c(2, 1, 2, 1), oma = c(1, 9, 2, 1), mgp = c(1, 0.75, 0))
  
  for(type in c('contact', 'tja', 'trruup')){
    plot(data_sets_date$dtw[[type]]$date, -data_sets_date$dtw[[type]]$d, 
         pch = 16, col = alpha('darkorange', 0),
         xlim = c(0, 25), ylim = c(-2, 2),
         xlab = '', ylab = '', xaxt = 'n', yaxt = 'n')
    plot.model.dates(all_models_out_date$dtw[[type]]$post, 
                     data_sets_date$dtw[[type]])
    plot.model.time(all_models_out_time$dtw[[type]]$post, 
                    data_sets_time$dtw[[type]])
    if(type == call_types[1]){
      axis(2)
      mtext('accoustic similarity', 2, 2, cex = 0.75)
      mtext('DTW', 2, 7, font = 2, las = 2, adj = 0.5)
    } 
    mtext(str_replace(type, '_', ' '), 3, 1, font = 2)
  }
  plot.new()
  mtext(str_replace(call_types[4], '_', ' '), 3, 1, font = 2)
  plot.new()
  mtext(str_replace(call_types[5], '_', ' '), 3, 1, font = 2)
  
  for(type in call_types){
    plot(data_sets_date$spcc[[type]]$date, -data_sets_date$spcc[[type]]$d, 
         pch = 16, col = alpha('darkorange', 0),
         xlim = c(0, 25), ylim = c(-2, 2),
         xlab = '', ylab = '', xaxt = 'n', yaxt = 'n')
    plot.model.dates(all_models_out_date$spcc[[type]]$post, 
                     data_sets_date$spcc[[type]])
    plot.model.time(all_models_out_time$spcc[[type]]$post, 
                    data_sets_time$spcc[[type]])
    if(type == call_types[1]){
      axis(2)
      mtext('accoustic similarity', 2, 2, cex = 0.75)
      mtext('SPCC', 2, 7, font = 2, las = 2, adj = 0.5)
    } 
    axis(1, (seq(-2, 2, 1) + 2) * 7.5, 10^seq(-2, 2, 1))
    axis(3, seq(0, 30, 5), seq(0, 30, 5))
    mtext('difference [minutes]', 1, 2, cex = 0.75)
    mtext('difference [days]', 3, 2, cex = 0.75)
  }
  
  for(type in call_types){
    plot(data_sets_date$specan[[type]]$date, -data_sets_date$specan[[type]]$d, 
         pch = 16, col = alpha('darkorange', 0),
         xlim = c(0, 25), ylim = c(-2, 2),
         xlab = '', ylab = '', xaxt = 'n', yaxt = 'n')
    plot.model.dates(all_models_out_date$specan[[type]]$post, 
                     data_sets_date$specan[[type]])
    plot.model.time(all_models_out_time$specan[[type]]$post, 
                    data_sets_time$specan[[type]])
    if(type == call_types[1]){
      axis(2)
      mtext('accoustic similarity', 2, 2, cex = 0.75)
      mtext('SPECAN', 2, 7, font = 2, las = 2, adj = 0.5)
    } 
  }
  
  dev.off()
}

