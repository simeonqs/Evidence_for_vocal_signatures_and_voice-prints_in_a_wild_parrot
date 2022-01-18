# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 27-09-2021
# Date last modified: 27-09-2021
# Author: Simeon Q. Smeele
# Description: Running DTW on the traces of isolated contact calls. 
# source('ANALYSIS/CODE/dtw/00_run_dtw.R')
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('data.table', 'tidyverse', 'warbleR', 'dtw', 'parallel')
for(lib in libraries){
  if(! lib %in% installed.packages()) lapply(lib, install.packages)
  lapply(lib, require, character.only = TRUE)
}

# Clean R
rm(list=ls()) 

# Paths
path_data = 'ANALYSIS/RESULTS/00_run_methods/all_data.RData'
path_functions = 'ANALYSIS/CODE/functions'
path_dtw_out = 'ANALYSIS/RESULTS/luscinia/dtw/m.RData'

# Load data
load(path_data)

# Subset smooth traces to only include call types for which DTW makes sense
smooth_traces = smooth_traces[which(names(smooth_traces) %in% 
                                      unlist(data_sets[c('contact', 'contact_mix', 
                                                         'short_contact', 'trruup', 
                                                         'kaw', 'tja', 'tjup', 
                                                         'tonal_mix', 'isolated_contact')]))]

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Running through the combinations -  DTW
l = length(smooth_traces)
c = combn(1:l, 2)
message(sprintf('Starting DTW for %s traces...', l))
out = mclapply(1:ncol(c), function(x) {
  i = c[1,x]
  j = c[2,x]
  dtw_out = dtw(smooth_traces[[i]], smooth_traces[[j]])
  return( dtw_out$normalizedDistance )
}, mc.cores = 4) %>% unlist # end running through the combinations
message('Done!')

# Making it into a matrix
o = out
o = o / max(o)
o = log(o)
hist(o)
m = o.to.m(o, names(smooth_traces))
rownames(m) = colnames(m) = names(smooth_traces)

# Save
save(m, file = path_dtw_out)

# Report
message(sprintf('Saved dtw results for %s calls.', l))
