# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: monk parakeets
# Date started: 20-10-2021
# Date last modified: 26-01-2022
# Author: Simeon Q. Smeele
# Description: Load the Luscina traces and filters out issues. 
# This version removes the bad traces if a path is supplied.
# This version makes the removal of bad traces optional. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

require(readxl)

load.traces = function(path_traces, path_bad_traces = NULL){
  
  # Load
  traces = read.csv(path_traces)
  
  # Clean traces
  traces = traces[!(traces$Song == '2020_11_16_121650-104.wav' & traces$Element == 1),]
  traces = traces[!(traces$Song == '2020_11_09_083040-4.wav' & traces$Element == 2),]
  traces = traces[!(traces$Song == '2020_11_09_083040-4.wav' & traces$Element == 3),]
  traces = traces[!(traces$Song == '2020_10_27_091634-63.wav' & traces$Element == 2),]
  traces = traces[!(traces$Song == '2020_11_01_170724-3.wav' & traces$Element == 2),]
  traces = traces[!(traces$Song == '2020_11_07_101750-11.wav' & traces$Element == 2),]
  
  # Remove bad traces for now
  if(!is.null(path_bad_traces)){
    bad_traces = read_xlsx(path_bad_traces)
    song_to_file_end = sapply(traces$Song, function(x){
      split = str_split(x, '_')
      pasted = paste(split[[1]][3], split[[1]][4], sep = '_')
      return(str_remove(pasted, '.wav'))
    }) 
    traces = traces[!song_to_file_end %in% bad_traces$file_end,]
  }
  
  # Return
  message(sprintf('Loaded %s traces.', length(unique(traces$Song))))
  return(traces)
  
}