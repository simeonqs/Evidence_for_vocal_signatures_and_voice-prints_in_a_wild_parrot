# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 19-10-2021
# Date last modified: 21-10-2021
# Author: Simeon Q. Smeele
# Description: Loading the selection tables and subsetting per call type. Saves subsetted data frames in 
# one object to be used in further steps. 
# This version adds the isolated contact calls that are also in Luscinia. 
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
path_traces = 'ANALYSIS/DATA/luscinia/all contact.csv'

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Load data 
st = load.selection.tables(path_selection_tables, path_annotations, path_context)
traces = load.traces(path_traces)

# Listing the call types to include - need to include more, just starting small
source(path_call_type_classification)

# Subset per call type and save
data_sets = lapply(names(types_include), function(type) st[st$`call type` %in% types_include[[type]],])
names(data_sets) = names(types_include)

# Find isolated contact calls
sub_iso = st[st$`call type` == 'contact',]
sub_iso = sub_iso[sub_iso$context %in% c('isolated', 'response'),]
traces$fs = str_remove(traces$Song, '.wav')
sub_iso = sub_iso[sub_iso$fs %in% traces$fs,]

# Adjust start and end times
sub_iso$Begin.Time..s. = sapply(sub_iso$fs, function(fs)
  sub_iso$Begin.Time..s.[sub_iso$fs == fs] - min(traces$Time[traces$fs == fs])/1000)
sub_iso$End.Time..s. = sapply(sub_iso$fs, function(fs)
  sub_iso$End.Time..s.[sub_iso$fs == fs] - min(traces$Time[traces$fs == fs])/1000)
# hist(sub_iso$End.Time..s. - sub_iso$Begin.Time..s.)

# Add
data_sets = append(data_sets, list(isolated_contact = sub_iso))
  
# Save
save(data_sets, file = path_out)
message(sprintf('Saved %s data frames in data_sets.RData!', length(data_sets)))