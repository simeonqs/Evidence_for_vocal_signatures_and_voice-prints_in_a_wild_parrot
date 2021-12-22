# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: chapter II  
# Date started: 26-08-2021
# Date last modified: 26-08-2021
# Author: Simeon Q. Smeele
# Description: This script takes the raw output of Luscinia for the contact calls, smoothens the traces, 
# runs dtw and outputs the results for the next step. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# DATA ----
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('data.table', 'tidyverse', 'warbleR', 'dtw', 'labdsv', 'parallel', 'umap', 'oce', 'signal',
              'readxl', 'rethinking')
for(lib in libraries){
  if(! lib %in% installed.packages()) lapply(lib, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Clean R
rm(list=ls()) 

# Paths
path_functions = 'ANALYSIS/CODE/functions'
path_traces = 'ANALYSIS/DATA/luscinia/all contact.csv'
path_out = 'ANALYSIS/RESULTS/luscinia/dtw/dtw_and_m.RData'

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Load traces
traces = load.traces(path_traces)

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# ANALYSIS ----
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Extract traces and smoothen
set.seed(1)
file_sels = sample(unique(traces$Song)) # randomise order
traces_smooth = mclapply(file_sels, function(file_sel){
  trace = traces$Fundamental_frequency[traces$Song == file_sel]
  new_trace = smooth.spline(trace, spar = 0.3) %>% fitted
  return(new_trace)
}, mc.cores = 4)

# Length of the original data
l = length(traces_smooth)

# Combinations
c = combn(1:l, 2)

# Running through the combinations -  DTW
dtw_outs = mclapply(1:ncol(c), function(x) {
  
  i = c[1,x]
  j = c[2,x]
  dtw_out = dtw(traces_smooth[[i]], traces_smooth[[j]])
  return( dtw_out$normalizedDistance )
  
}, mc.cores = 4) %>% unlist # end running through the combinations
dtw_outs_with_names = list(dtw_outs = dtw_outs, file_sels = file_sels)

# Making it into a matrix
o = dtw_outs_with_names$dtw_outs
o = o / max(o)
m = o.to.m(o, file_sels)

# Save
save(dtw_outs_with_names, m, file = path_out)

