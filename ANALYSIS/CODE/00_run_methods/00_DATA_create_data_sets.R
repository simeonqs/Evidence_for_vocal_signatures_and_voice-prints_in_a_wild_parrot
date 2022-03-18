# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 19-10-2021
# Date last modified: 08-03-2022
# Author: Simeon Q. Smeele
# Description: Loading the selection tables and subsetting per call type. Saves subsetted data frames in 
# one object to be used in further steps. 
# source('ANALYSIS/CODE/00_run_methods/00_DATA_create_data_sets.R)
# This version adds the isolated contact calls that are also in Luscinia. 
# This version switches to the 2021 data with all start and end coming from Luscinia. 
# This version also reads in the waves and saves them in a separate object. 
# This version loads data from both years and renames all objects with year subscript.
# This version combines data from both years. 
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
st_20 = load.selection.tables(path_selection_tables, path_annotations = path_annotations_2020,
                              path_context = path_context)
st_21 = load.selection.tables(path_selection_tables, path_annotations_2021 = path_annotations_2021)
traces_20_contact = load.traces(path_traces_2020_contact, path_bad_traces_2020)
traces_20_remaining = load.traces(path_traces_2020_remaining, path_bad_traces_2020)
traces_20 = rbind(traces_20_contact, traces_20_remaining)
traces_21 = load.traces(path_traces_2021, path_bad_traces_2021)

# Remove handling and release from 2021 data
st_21 = st_21[!str_detect(st_21$file, '10_26'),]
st_21 = st_21[!str_detect(st_21$file, '10_27'),]

# Extract traces, smoothen and padd
smooth_traces_20 = smooth.traces(traces_20)
smooth_traces_21 = smooth.traces(traces_21)

# Subset st per year, include only calls with traces
st_20 = subset.st(st_20, '2020', traces_20)
st_21 = subset.st(st_21, '2021', traces_21)

# Remove all traces that are not any longer in the selection tables and report them
not_st = names(smooth_traces_20)[!names(smooth_traces_20) %in% st_20$fs]
message(sprintf('Missing %s calls in selection tables, showing first six', length(not_st)))
if(length(not_st) > 0) print(head(not_st))
smooth_traces_20 = smooth_traces_20[st_20$fs]

not_st = names(smooth_traces_21)[!names(smooth_traces_21) %in% st_21$fs]
message(sprintf('Missing %s calls in selection tables, showing first six', length(not_st)))
if(length(not_st) > 0) print(head(not_st))
smooth_traces_21 = smooth_traces_21[st_21$fs]

# Adjust start and end times
st_20 = adjust.times(st_20, traces_20)
st_21 = adjust.times(st_21, traces_21)

# Subset per call type and save
data_sets_20 = create.data.sets(st_20, path_call_type_classification, path_sorted_loud_contact_20)
data_sets_21 = create.data.sets(st_21, path_call_type_classification, path_sorted_loud_contact_21)

# Load waves
message('Loading waves...')
waves_20 = mclapply(1:nrow(st_20), function(i)
  load.wave(path_audio_file = paste0(path_audio_20, '/', st_20$file[i], '.wav'), 
            from = st_20$Begin.Time..s.[i],
            to = st_20$End.Time..s.[i]), mc.cores = 4)
names(waves_20) = st_20$fs
waves_21 = mclapply(1:nrow(st_21), function(i)
  load.wave(path_audio_file = paste0(path_audio_21, '/', st_21$file[i], '.wav'), 
            from = st_21$Begin.Time..s.[i],
            to = st_21$End.Time..s.[i]), mc.cores = 4)
names(waves_21) = st_21$fs
message('Done!')

# Test duration of waves
durs_20 =  sapply(waves_20, function(x) length(x@left))
durs_21 =  sapply(waves_21, function(x) length(x@left))
if(any(durs_20 < 0.02 * 44100)) stop('Waves 20 too short.')
if(any(durs_21 < 0.02 * 44100)) stop('Waves 21 too short.')
if(any(durs_20 > 2 * 44100)) stop('Waves 20 too long.')
if(any(durs_21 > 2 * 44100)) stop('Waves 21 too long.')

# Combine years
st_20$`complete sequence` = NA
st_20$notes = NA
st_21$notes.x = NA
st_21$notes.y = NA
st_21$...8 = NA
st = rbind(st_20, st_21)
waves = append(waves_20, waves_21)
data_sets = lapply(names(data_sets_20), function(type) c(data_sets_20[[type]], data_sets_21[[type]]))
names(data_sets) = names(data_sets_20)
smooth_traces = append(smooth_traces_20, smooth_traces_21)

# Save
save(st, smooth_traces, data_sets, file = path_data)
save(waves, file = path_waves)
message('Saved all data!')