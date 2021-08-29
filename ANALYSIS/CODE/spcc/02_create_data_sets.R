# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 27-08-2021
# Date last modified: 27-08-2021
# Author: Simeon Q. Smeele
# Description: Creates a dataset per call type including the subsetted distance matrix from spcc, and a 
# data.frame with file, file_sel, and ind. 
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
path_o = 'ANALYSIS/RESULTS/spcc/o_with_names.RData'
path_out = 'ANALYSIS/RESULTS/spcc/datasets per call type'
path_selection_tables = 'ANALYSIS/DATA/selection tables'
path_annotations = 'ANALYSIS/DATA/overview recordings/annotations.csv'
path_context = 'ANALYSIS/DATA/overview recordings/call types.xlsx'

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Load data 
load(path_o)
st = load.selection.tables(path_selection_tables, path_annotations, path_context)

# Create dist mat
m = o.to.m(o_with_names$o, o_with_names$file_sels)

# Get files and inds
d = data.frame(file_sel = o_with_names$file_sels,
               file = o_with_names$file_sels %>% strsplit('-') %>% sapply(`[`, 1))
d$ind = sapply(d$file_sel, function(fs) st$bird[st$fs == fs])

# Listing the call types to include - need to include more, just starting small
unique(context$`call type`)
types_include = list(contact = c('contact', 'contact or contact-like'), 
                     short_contact = c('short contact', 'tjup (short contact)'),
                     growl = c('growl (upsweep)', 'growl', 'growl (kraa)', 'growl (kree)', 
                               'growl (downsweep)'),
                     trruup = 'trruup',
                     tjup = c('tjup', 'tjep', 'tjup (ladder)'),
                     tja = c('tja', 'tjagrrt', 'tja (tjiep)'),
                     alarm = c('alarm', 'growl or alarm', 'short alarm'))

# Run through them and save
for(type in names(types_include)){
  subber = d$file_sel %in% st$fs[st$`call type` %in% types_include[[type]]]
  d_sub = d[subber,]
  m_sub = m[subber, subber]
  save(d_sub, m_sub, file = sprintf('%s/%s.RData', path_out, type))
}