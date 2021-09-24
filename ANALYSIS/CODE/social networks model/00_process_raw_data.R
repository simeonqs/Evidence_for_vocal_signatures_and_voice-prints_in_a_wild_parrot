# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: chapter II
# Date started: 24-08-2021
# Date last modified: 23-09-2021
# Author: Simeon Q. Smeele
# Description: Load DTW results and prepare for model.
# NOTE: downsampling for now!
# This version adds data to code whether or not an ind pair is the same ind. 
# This version adds the rec level and is moved to the new repo. 
# This version adds the same rec vector. 
# This version includes time between recordings. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('rethinking', 'warbleR', 'MASS', 'tidyverse', 'readxl', 'umap')
for(lib in libraries){
  if(! lib %in% installed.packages()) lapply(lib, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Clean R
rm(list=ls()) 

# Settings
N_obs = 100

# Paths
path_functions = 'ANALYSIS/CODE/functions'
path_out = 'ANALYSIS/RESULTS/social networks model/real_dat.RData'
path_dtw = 'ANALYSIS/RESULTS/luscinia/dtw/dtw_and_m.RData'
path_anno = 'ANALYSIS/DATA/overview recordings/annotations.csv'
path_context = 'ANALYSIS/DATA/overview recordings/call types.xlsx'
path_st = 'ANALYSIS/DATA/selection tables'

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Load data
load(path_dtw)
dat = load.selection.tables(path_st, path_anno)
anno = read.csv2(path_anno)

# Get ind and rec
dat$fs = paste(dat$file, dat$Selection, sep = '-')
fs = rownames(m) %>% str_remove('.wav')
files = fs %>% str_split('-') %>% sapply(`[`, 1)
inds = sapply(fs, function(x) anno$bird[anno$annotation_ref == dat$Annotation[dat$fs == x]])

# Sample down for now 
set.seed(1)
s = sample(1:length(fs), N_obs)
m = m[s, s]
files = files[s]
inds = inds[s]

# List data
d = m.to.df(m, inds = as.integer(as.factor(inds)), recs = files, incl_time = T)
clean_dat = as.list(d)
clean_dat$d = as.numeric(scale(d$d))
clean_dat$N_ind_pair = max(d$ind_pair)
clean_dat$N_rec_pair = max(d$rec_pair)
clean_dat$N_ind = max(d$ind_i)
clean_dat$N_rec = max(d$rec_i)
clean_dat$N_call = max(d$call_j)
clean_dat$N_obs = length(d$call_i)
clean_dat$same_ind = sapply(1:max(d$ind_pair), function(pair) # 1 = same, 0 = different
  ifelse(clean_dat$ind_i[clean_dat$ind_pair == pair][1] == 
           clean_dat$ind_j[clean_dat$ind_pair == pair][1], 1, 0))
clean_dat$same_rec = sapply(1:max(d$rec_pair), function(pair) # 1 = same, 0 = different
  ifelse(clean_dat$rec_i[clean_dat$rec_pair == pair][1] == 
           clean_dat$rec_j[clean_dat$rec_pair == pair][1], 1, 0))

# Save
save(clean_dat, file = path_out)
