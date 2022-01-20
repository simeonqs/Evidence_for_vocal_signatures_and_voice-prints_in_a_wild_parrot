# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 19-10-2021
# Date last modified: 19-01-2022
# Author: Simeon Q. Smeele
# Description: Loading the selection tables and subsetting per call type. Saves subsetted data frames in 
# one object to be used in further steps. 
# source('ANALYSIS/CODE/00_run_methods/00_DATA_create_data_sets.R)
# This version adds the isolated contact calls that are also in Luscinia. 
# This version switches to the 2021 data with all start and end coming from Luscinia. 
# This version also reads in the waves and saves them in a seperate object. 
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
path_out = 'ANALYSIS/RESULTS/00_run_methods/all_data.RData'
path_waves = 'ANALYSIS/RESULTS/00_run_methods/waves.RData'
path_selection_tables = 'ANALYSIS/DATA/selection tables'
path_annotations_2021 = 'ANALYSIS/DATA/overview recordings/annotations - 2021.xlsx'
# path_annotations = 'ANALYSIS/DATA/overview recordings/annotations.csv'
# path_context = 'ANALYSIS/DATA/overview recordings/call types.xlsx'
path_call_type_classification = 'ANALYSIS/CODE/call type classification.R'
path_traces = 'ANALYSIS/DATA/luscinia/temp_2021_traces.csv'
path_bad_traces = '/Users/ssmeele/OFFLINE/luscinia/bad_files_2021.xlsx'
path_audio = '/Volumes/Elements 3/BARCELONA_2021/audio'

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Load data 
st = load.selection.tables(path_selection_tables, path_annotations_2021 = path_annotations_2021)
traces = load.traces(path_traces, path_bad_traces)

# Extract traces, smoothen and padd
message(sprintf('Starting the smoothening of %s traces...', length(unique(traces$Song))))
calls = unique(traces$Song)
smooth_traces = mclapply(calls, function(call){
  trace = traces$Fundamental_frequency[traces$Song == call]
  time = traces$Time[traces$Song == call]
  fit = gap.filler(time, trace)
  new_trace = smooth.spline(fit, spar = 0.4) %>% fitted
  return(new_trace)
}, mc.cores = 4)
names(smooth_traces) = str_remove(calls, '.wav')
message('Done.')

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
if(any(st$End.Time..s.-st$Begin.Time..s. > 3)) stop('Some calls are too long.')

# Listing the call types to include - need to include more, just starting small
source(path_call_type_classification)

# Subset per call type and save
data_sets = lapply(names(types_include), function(type) st$fs[st$`call type` %in% types_include[[type]]])
names(data_sets) = names(types_include)

# # Find isolated contact calls
# sub_iso = st[st$`call type` == 'contact',]
# sub_iso = sub_iso[sub_iso$context %in% c('isolated', 'response'),]
# sub_iso = sub_iso[sub_iso$fs %in% traces$fs,]
# 
# # Add
# data_sets = append(data_sets, list(isolated_contact = sub_iso$fs))

# Load waves
message('Loading waves...')
waves = lapply(1:nrow(st), function(i)
  load.wave(path_audio_file = paste0(path_audio, '/', st$file[i], '.wav'), 
            from = st$Begin.Time..s.[i],
            to = st$End.Time..s.[i]))
message('Done!')
  
# Save
save(st, smooth_traces, traces, data_sets, file = path_out)
save(waves, file = path_waves)
message('Saved all data!')
