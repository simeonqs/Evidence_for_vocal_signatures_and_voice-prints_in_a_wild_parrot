# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: monk parakeets
# Date started: 20-10-2021
# Date last modified: 20-10-2021
# Author: Simeon Q. Smeele
# Description: Load the Luscina traces and filters out issues. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

load.traces = function(path_traces){
  
  traces = read.csv(path_traces)
  message(sprintf('Loaded %s traces.', length(unique(traces$Song))))
  
  # Clean traces
  traces = traces[!(traces$Song == '2020_11_16_121650-104.wav' & traces$Element == 1),]
  traces = traces[!(traces$Song == '2020_11_09_083040-4.wav' & traces$Element == 2),]
  traces = traces[!(traces$Song == '2020_11_09_083040-4.wav' & traces$Element == 3),]
  traces = traces[!(traces$Song == '2020_10_27_091634-63.wav' & traces$Element == 2),]
  traces = traces[!(traces$Song == '2020_11_01_170724-3.wav' & traces$Element == 2),]
  traces = traces[!(traces$Song == '2020_11_07_101750-11.wav' & traces$Element == 2),]
  
  return(traces)
  
}