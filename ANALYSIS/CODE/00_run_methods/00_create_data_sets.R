# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 19-10-2021
# Date last modified: 19-10-2021
# Author: Simeon Q. Smeele
# Description: Loading the selection tables and subsetting per call type. Saves subsetted data frames in 
# one object to be used in further steps. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('tidyverse')
for(lib in libraries){
  if(! lib %in% installed.packages()) lapply(lib, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Clean R
rm(list=ls()) 

# Paths
path_functions = 'ANALYSIS/CODE/functions'
path_out = 'ANALYSIS/RESULTS/00_run_methods/data_sets.RData'
path_selection_tables = 'ANALYSIS/DATA/selection tables'
path_annotations = 'ANALYSIS/DATA/overview recordings/annotations.csv'
path_context = 'ANALYSIS/DATA/overview recordings/call types.xlsx'
path_call_type_classification = 'ANALYSIS/CODE/call type classification.R'

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Load data 
st = load.selection.tables(path_selection_tables, path_annotations, path_context)

# Listing the call types to include - need to include more, just starting small
source(path_call_type_classification)

# Subset per call type and save
data_sets = lapply(names(types_include), function(type) st[st$`call type` %in% types_include[[type]],])
names(data_sets) = names(types_include)

# Save
save(data_sets, file = path_out)
message(sprintf('Saved %s data frames in data_sets.RData!', length(data_sets)))