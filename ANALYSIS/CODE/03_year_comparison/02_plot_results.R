# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 30-01-2022
# Date last modified: 04-04-2022
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
path_model_results = 'ANALYSIS/RESULTS/03_year_comparison'
path_figure_time = 'ANALYSIS/RESULTS/03_year_comparison/results.pdf'

# Import functions
# .functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Load data
load(path_data)

# List models
models = list.files(path_model_results, '*post*', full.names = T)

# Functions to plot
plot.model = function(path_model, yaxt = 'n', xaxt = 'n'){
  load(path_model)
  plot(NULL, xlim = c(-0.5, 1.5), ylim = c(0, 15), main = '', 
       xlab = '', ylab = '', xaxt = xaxt, yaxt = yaxt)
  abline(v = 0, col = alpha(1, 0.5), lwd = 5, lty = 2)
  sapply(1:2000, function(i) (post$z_year[i,2] - post$z_year[i,1]) * post$sigma_year[i]) %>% 
    density %>% lines(col = alpha(4, 1), lwd = 5, lty = 1)
  text(1.25, 13, sprintf('N = %s', ncol(post$z_call)), adj = 1)
}

# Order call types
call_types = c('contact', 'tja', 'trruup', 'alarm', 'growl')

# Plot beta parameter per call type
pdf(path_figure_time, 10, 5)
par(mfrow = c(3, 5), mar = c(1, 1, 0, 0), oma = c(3, 9, 3, 1), mgp = c(1, 0.75, 0))

plot.model(models[str_detect(models, 'dtw_contact')], yaxt = 'l')
mtext('contact', 3, 1, font = 2)
mtext('density', 2, 2, cex = 0.75)
mtext('DTW', 2, 7, font = 2, las = 2, adj = 0.5)
plot.model(models[str_detect(models, 'dtw_tja')])
mtext('tja', 3, 1, font = 2)
plot.model(models[str_detect(models, 'dtw_trruup')])
mtext('trruup', 3, 1, font = 2)
plot.new()
mtext('alarm', 3, 1, font = 2)
plot.new()
mtext('growl', 3, 1, font = 2)

plot.model(models[str_detect(models, 'spcc_contact')], yaxt = 'l')
mtext('density', 2, 2, cex = 0.75)
mtext('SPCC', 2, 7, font = 2, las = 2, adj = 0.5)
plot.model(models[str_detect(models, 'spcc_tja')])
plot.model(models[str_detect(models, 'spcc_trruup')])
plot.model(models[str_detect(models, 'spcc_alarm')])
plot.model(models[str_detect(models, 'spcc_growl')])

plot.model(models[str_detect(models, 'mfcccc_contact')], yaxt = 'l', xaxt = 'l')
mtext('density', 2, 2, cex = 0.75)
mtext('MFCCCC', 2, 7, font = 2, las = 2, adj = 0.5)
mtext('beta', 1, 2, cex = 0.75)
plot.model(models[str_detect(models, 'mfcccc_tja')], xaxt = 'l')
mtext('beta', 1, 2, cex = 0.75)
plot.model(models[str_detect(models, 'mfcccc_trruup')], xaxt = 'l')
mtext('beta', 1, 2, cex = 0.75)
plot.model(models[str_detect(models, 'mfcccc_alarm')], xaxt = 'l')
mtext('beta', 1, 2, cex = 0.75)
plot.model(models[str_detect(models, 'mfcccc_growl')], xaxt = 'l')
mtext('beta', 1, 2, cex = 0.75)

dev.off()

message('Done')