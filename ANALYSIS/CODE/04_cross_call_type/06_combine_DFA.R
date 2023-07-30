# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 24-03-2023
# Date last modified: 15-05-2023
# Author: Simeon Q. Smeele
# Description: Combining all pDFA results in a table. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('dplyr', 'stringr')
for(i in libraries){
  if(! i %in% installed.packages()) lapply(i, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Clean R
rm(list=ls()) 

# Paths
source('ANALYSIS/CODE/paths.R')

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Load data
load(path_pdfa_full)
load(path_pdfa_permuted)
load(path_pdfa_subset)

# Bind
pdfa_total = rbind(pdfa_full, pdfa_subset, pdfa_permuted)
pdfa_total$sample_size = as.character(pdfa_total$sample_size)
pdfa_total[, sapply(pdfa_total, is.numeric)] = 
  lapply(pdfa_total[, sapply(pdfa_total, is.numeric)], function(x) format(x, nsmall = 2))
pdfa_total = data.frame(lapply(pdfa_total, as.character), stringsAsFactors = FALSE)
names(pdfa_total) = names(pdfa_total) |> str_replace('_', ' ')
names(pdfa_total)[1] = 'pDFA type'

# Save
write.csv(pdfa_total, path_csv_pdfa, quote = FALSE, row.names = FALSE)
