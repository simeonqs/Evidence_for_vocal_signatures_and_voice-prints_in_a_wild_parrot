# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: chapter II
# Date started: 24-08-2021
# Date last modified: 27-08-2021
# Author: Simeon Q. Smeele
# Description: Load DTW results and prepare for model. NOT FINISHED.
# setwd('/Users/ssmeele/ownCloud/Simeon/MPI AB/PhD thesis/Chapter II/phd_chapter_II')
# NOTE: subsampling inds to test model, REMEMBER TO INCLUDE ALL
# This version adds data to code whether or not an ind pair is the same ind. 
# This version adds the rec level. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('rethinking', 'warbleR', 'MASS', 'tidyverse', 'readxl', 'umap')
for(lib in libraries){
  if(! lib %in% installed.packages()) lapply(lib, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Clean R
rm(list=ls()) 

# Paths
path_functions = 'ANALYSIS/CODE/social networks model/functions'
path_functions_all = 'ANALYSIS/CODE/functions'
path_out = 'ANALYSIS/RESULTS/social networks model/real_dat.RData'
path_dtw = 'ANALYSIS/RESULTS/Luscinia/dtw_outs_with_names.RData'
path_anno = 'ANALYSIS/DATA/overview recordings/annotations.csv'
path_context = 'ANALYSIS/DATA/overview recordings/call types.xlsx'

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)
.functions = sapply(list.files(path_functions_all, pattern = '*R', full.names = T), source)

# Load data
load(path_dtw)
dat = load.selection.tables('ANALYSIS/DATA/selection tables')

# Merge annotations
annotations = read.csv2(path_anno)
dat = merge(dat, annotations, by.x = 'Annotation', by.y = 'annotation_ref',
            all.x = T, all.y = F)

# Load context
context = load.call.type.context(path_context)
pasted = paste0(str_remove(context$file, '.Table.1.selections.txt'), '-', context$selection)
isolated_contacts = pasted[context$`call type` == 'contact' & context$context %in% c('isolated', 'response')]

# Create matrix
o = dtw_outs_with_names$dtw_outs
m = o.to.m(o, inds)
l = length(dtw_outs_with_names$file_sels)
o = o / max(o)
m = matrix(nrow = l, ncol = l)
m[lower.tri(m)] = o
m[upper.tri(m)] = t(m)[upper.tri(m)]
diag(m) = 0
file_sels = dtw_outs_with_names$file_sels %>% str_remove('.wav')

# Subset
m = m[file_sels %in% isolated_contacts, file_sels %in% isolated_contacts]
fs = file_sels[file_sels %in% isolated_contacts]

# Get individual ID
dat$file_sel = paste(dat$file, dat$Selection, sep = '-')
inds = sapply(fs, function(x) dat$bird[dat$file_sel == x])

# Sample down inds for now 
set.seed(1)
s = sample(unique(inds), 15)
m = m[inds %in% s, inds %in% s]
inds = inds[inds %in% s]

# List data
d = m.to.df(m, as.integer(as.factor(inds)))
clean_dat = as.list(d)
clean_dat$d = as.numeric(scale(d$d))
clean_dat$N_ind_pair = max(d$ind_pair)
clean_dat$N_ind = max(d$ind_i)
clean_dat$N_call = max(d$call_j)
clean_dat$N_obs = length(d$call_i)
clean_dat$same_ind = sapply(1:max(d$ind_pair), function(pair) # 1 = same, 0 = different
  ifelse(clean_dat$ind_i[clean_dat$ind_pair == pair][1] == 
           clean_dat$ind_j[clean_dat$ind_pair == pair][1], 1, 0))

# Save
save(clean_dat, file = path_out)
