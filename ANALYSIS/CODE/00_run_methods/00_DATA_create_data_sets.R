# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 19-10-2021
# Date last modified: 25-01-2022
# Author: Simeon Q. Smeele
# Description: Loading the selection tables and subsetting per call type. Saves subsetted data frames in 
# one object to be used in further steps. 
# source('ANALYSIS/CODE/00_run_methods/00_DATA_create_data_sets.R)
# This version adds the isolated contact calls that are also in Luscinia. 
# This version switches to the 2021 data with all start and end coming from Luscinia. 
# This version also reads in the waves and saves them in a separate object. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('tidyverse', 'parallel')
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
st = load.selection.tables(path_selection_tables, path_annotations_2021 = path_annotations_2021)
traces = load.traces(path_traces, path_bad_traces)

# Remove handling and release for now
st = st[!str_detect(st$file, '10_26'),]
st = st[!str_detect(st$file, '10_27'),]

# Extract traces, smoothen and padd
message(sprintf('Starting the smoothening of %s traces...', length(unique(traces$Song))))
calls = unique(traces$Song)
smooth_traces = mclapply(calls, function(call){
  trace = traces$Fundamental_frequency[traces$Song == call]
  time = traces$Time[traces$Song == call]
  fit = gap.filler(time, trace)
  new_trace = smooth.spline(fit, spar = 0.1) %>% fitted
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

# Names rows
rownames(st) = st$fs

# Remove all traces that are not any longer in the selection tables and report them
not_st = names(smooth_traces)[!names(smooth_traces) %in% st$fs]
message(sprintf('Missing %s calls in selection tables, showing first six', length(not_st)))
print(head(not_st))
smooth_traces = smooth_traces[st$fs]

# Adjust start and end times
st$End.Time..s. = sapply(st$fs, function(fs)
  st$Begin.Time..s.[st$fs == fs] + max(traces$Time[traces$fs == fs])/1000)
st$Begin.Time..s. = sapply(st$fs, function(fs)
  st$Begin.Time..s.[st$fs == fs] + min(traces$Time[traces$fs == fs])/1000)
if(any(st$End.Time..s.-st$Begin.Time..s. > 3)) stop('Some calls are too long.')

# Listing the call types to include - need to include more, just starting small
source(path_call_type_classification)

# Subset per call type and save
data_sets = lapply(names(types_include), function(type) st$fs[st$`call type` %in% types_include[[type]]])
names(data_sets) = names(types_include)
loud_contact = path_sorted_loud_contact %>% list.files('*wav') %>% str_remove('.wav')
loud_contact = loud_contact[loud_contact %in% data_sets$contact]
data_sets$loud_contact = loud_contact

# # Find isolated contact calls
# sub_iso = st[st$`call type` == 'contact',]
# sub_iso = sub_iso[sub_iso$context %in% c('isolated', 'response'),]
# sub_iso = sub_iso[sub_iso$fs %in% traces$fs,]
# 
# # Add
# data_sets = append(data_sets, list(isolated_contact = sub_iso$fs))

# Load waves
message('Loading waves...')
waves = mclapply(1:nrow(st), function(i)
  load.wave(path_audio_file = paste0(path_audio, '/', st$file[i], '.wav'), 
            from = st$Begin.Time..s.[i],
            to = st$End.Time..s.[i]), mc.cores = 4)
names(waves) = st$fs
message('Done!')
  
# Save
save(st, smooth_traces, data_sets, file = path_data)
save(waves, file = path_waves)
message('Saved all data!')