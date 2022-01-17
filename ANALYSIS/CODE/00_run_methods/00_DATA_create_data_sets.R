# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 19-10-2021
# Date last modified: 17-01-2022
# Author: Simeon Q. Smeele
# Description: Loading the selection tables and subsetting per call type. Saves subsetted data frames in 
# one object to be used in further steps. 
# This version adds the isolated contact calls that are also in Luscinia. 
# This version switches to the 2021 data with all start and end coming from Luscinia. 
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
path_annotations_2021 = 'ANALYSIS/DATA/overview recordings/annotations - 2021.xlsx'
# path_annotations = 'ANALYSIS/DATA/overview recordings/annotations.csv'
# path_context = 'ANALYSIS/DATA/overview recordings/call types.xlsx'
path_call_type_classification = 'ANALYSIS/CODE/call type classification.R'
path_traces = 'ANALYSIS/DATA/luscinia/temp_2021_traces.csv'
path_bad_traces = '/Users/ssmeele/Desktop/bad_files_2021.xlsx'

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Load data 
st = load.selection.tables(path_selection_tables, path_annotations_2021 = path_annotations_2021)
traces = load.traces(path_traces, path_bad_traces)

# Remove all calls that are not in Luscinia and print them
traces$fs = str_remove(traces$Song, '.wav')
not_luscinia = unique(st$fs[!st$fs %in% traces$fs])
message(sprintf('Missing %s calls in Luscinia, showing first six', length(not_luscinia)))
print(head(not_luscinia))
st = st[!st$fs %in% not_luscinia,]

# Adjust start and end times
st$Begin.Time..s. = sapply(st$fs, function(fs)
  st$Begin.Time..s.[st$fs == fs] - min(traces$Time[traces$fs == fs])/1000)
st$End.Time..s. = sapply(st$fs, function(fs)
  st$End.Time..s.[st$fs == fs] - min(traces$Time[traces$fs == fs])/1000)

# Listing the call types to include - need to include more, just starting small
source(path_call_type_classification)

# Subset per call type and save
data_sets = lapply(names(types_include), function(type) st[st$`call type` %in% types_include[[type]],])
names(data_sets) = names(types_include)

# Find isolated contact calls
sub_iso = st[st$`call type` == 'contact',]
sub_iso = sub_iso[sub_iso$context %in% c('isolated', 'response'),]
sub_iso = sub_iso[sub_iso$fs %in% traces$fs,]

# Add
data_sets = append(data_sets, list(isolated_contact = sub_iso))
  
# Save
save(data_sets, file = path_out)
message(sprintf('Saved %s data frames in data_sets.RData!', length(data_sets)))
