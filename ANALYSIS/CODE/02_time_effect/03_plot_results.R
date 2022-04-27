# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 23-03-2022
# Date last modified: 24-03-2022
# Author: Simeon Q. Smeele
# Description: Plotting model results per method.  
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
path_time = 'ANALYSIS/RESULTS/02_time_effect'

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# List files
files_time = list.files(path_time, 'vsrm_time*', full.names = T)
files_dates = list.files(path_time, 'vsrm_dates*', full.names = T)

# Functions to plot
plot.model.time = function(path){
  load(path)
  for(i in sample(1:length(post$a_bar), 20)) 
    lines((c(-2, 1.3) + 2) * 7.5, -(post[['a_bar']][i] + c(-2, 1.3) * post[['b_bar']][i]), 
          col = alpha('purple', 0.3), lwd = 5, lty = 1)
}
plot.model.dates = function(path){
  load(path)
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
  plot(NULL, 
       xlim = c(0, 25), ylim = c(-3, 3),
       xlab = '', ylab = '', xaxt = 'n', yaxt = 'n')
  plot.model.time(files_time[str_detect(files_time, sprintf('dtw_%s', type))])
  plot.model.dates(files_dates[str_detect(files_dates, sprintf('dtw_%s', type))])
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
  plot(NULL,
       xlim = c(0, 25), ylim = c(-2, 2),
       xlab = '', ylab = '', xaxt = 'n', yaxt = 'n')
  plot.model.time(files_time[str_detect(files_time, sprintf('spcc_%s', type))])
  plot.model.dates(files_dates[str_detect(files_dates, sprintf('spcc_%s', type))])
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
  plot(NULL,
       xlim = c(0, 25), ylim = c(-2, 2),
       xlab = '', ylab = '', xaxt = 'n', yaxt = 'n')
  plot.model.time(files_time[str_detect(files_time, sprintf('mfcccc_%s', type))])
  plot.model.dates(files_dates[str_detect(files_dates, sprintf('mfcccc_%s', type))])
  if(type == call_types[1]){
    axis(2)
    mtext('accoustic similarity', 2, 2, cex = 0.75)
    mtext('MFCCCC', 2, 7, font = 2, las = 2, adj = 0.5)
  } 
}

dev.off()


