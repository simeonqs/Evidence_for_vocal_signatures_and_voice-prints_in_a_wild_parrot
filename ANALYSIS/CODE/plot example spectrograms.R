# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 07-04-2022
# Date last modified: 07-04-2022
# Author: Simeon Q. Smeele
# Description: Plotting spectrograms of the call types for sups. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('tidyverse', 'warbleR')
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
load(path_data)
load(path_waves)

pdf(path_pdf_example_spectrograms, 8, 5)
par(mfrow = c(3, 5), oma = c(1, 1, 4, 1))
better.spectro(ffilter(waves[[data_sets$contact[17]]], from = 300, output = 'Wave'), 
               ylim = c(0, 15000), xlim = c(0, 0.2))
mtext('contact', 3, 2, font = 2)
better.spectro(ffilter(waves[[data_sets$tja[6]]], from = 300, output = 'Wave'), 
               ylim = c(0, 15000), xlim = c(0, 0.2))
mtext('tja', 3, 2, font = 2)
better.spectro(ffilter(waves[[data_sets$trruup[63]]], from = 300, output = 'Wave'), 
               ylim = c(0, 15000), xlim = c(0, 0.2))
mtext('trruup', 3, 2, font = 2)
better.spectro(ffilter(waves[[data_sets$alarm[34]]], from = 300, output = 'Wave'), 
               ylim = c(0, 15000), xlim = c(0, 0.2))
mtext('alarm', 3, 2, font = 2)
better.spectro(ffilter(waves[[data_sets$growl[10]]], from = 300, output = 'Wave'), 
               ylim = c(0, 15000), xlim = c(0, 0.2))
mtext('growl', 3, 2, font = 2)
better.spectro(ffilter(waves[[data_sets$contact[101]]], from = 300, output = 'Wave'), 
               ylim = c(0, 15000), xlim = c(0, 0.2))
better.spectro(ffilter(waves[[data_sets$tja[101]]], from = 300, output = 'Wave'), 
               ylim = c(0, 15000), xlim = c(0, 0.2))
better.spectro(ffilter(waves[[data_sets$trruup[15]]], from = 300, output = 'Wave'), 
               ylim = c(0, 15000), xlim = c(0, 0.2))
better.spectro(ffilter(waves[[data_sets$alarm[103]]], from = 300, output = 'Wave'), 
               ylim = c(0, 15000), xlim = c(0, 0.2))
better.spectro(ffilter(waves[[data_sets$growl[102]]], from = 300, output = 'Wave'), 
               ylim = c(0, 15000), xlim = c(0, 0.2))
better.spectro(ffilter(waves[[data_sets$contact[506]]], from = 300, output = 'Wave'), 
               ylim = c(0, 15000), xlim = c(0, 0.2))
better.spectro(ffilter(waves[[data_sets$tja[51]]], from = 300, output = 'Wave'), 
               ylim = c(0, 15000), xlim = c(0, 0.2))
better.spectro(ffilter(waves[[data_sets$trruup[110]]], from = 300, output = 'Wave'), 
               ylim = c(0, 15000), xlim = c(0, 0.2))
better.spectro(ffilter(waves[[data_sets$alarm[201]]], from = 300, output = 'Wave'), 
               ylim = c(0, 15000), xlim = c(0, 0.2))
better.spectro(ffilter(waves[[data_sets$growl[221]]], from = 300, output = 'Wave'), 
               ylim = c(0, 15000), xlim = c(0, 0.2))
dev.off()

