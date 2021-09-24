# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 27-08-2021
# Date last modified: 23-09-2021
# Author: Simeon Q. Smeele
# Description: Running simple mantle test controlling for rec per call type. 
# source('ANALYSIS/CODE/mfcc/01_run_mantels.R')
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('vegan', 'tidyverse')
for(lib in libraries){
  if(! lib %in% installed.packages()) lapply(lib, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Clean R
rm(list=ls()) 

# Paths
path_data = 'ANALYSIS/RESULTS/mfcc/datasets per call type'
path_functions = 'ANALYSIS/CODE/functions'
path_out = 'ANALYSIS/RESULTS/mfcc/mantel results.txt'

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Run partial mantel per data set 
data_sets = list.files(path_data, full.names = T, pattern = '*RData')
results = lapply(data_sets, run.partial.mantel)

# Write outputs to text file
output = sapply(1:length(data_sets), function(i) 
  sprintf('For %s r = %s and p = %s.',
          data_sets[i] %>% str_remove(paste0(path_data, '/')) %>% str_remove('.RData'),
          round(results[[i]]$statistic, 2), 
          round(results[[i]]$signif, 2)))
write.table(output, path_out, quote = F, row.names = F, col.names = F) 
  
  
  