# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: chapter II  
# Date started: 26-08-2021
# Date last modified: 26-08-2021
# Author: Simeon Q. Smeele
# Description: Running simple mantle test controlling for rec. 
# source('ANALYSIS/CODE/luscinia/01_run_mantel.R')
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('vegan', 'tidyverse')
for(lib in libraries){
  if(! lib %in% installed.packages()) lapply(lib, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Clean R
rm(list=ls()) 

# Paths
path_data = 'ANALYSIS/RESULTS/luscinia/dtw/dtw_and_m.RData'
path_anno = 'ANALYSIS/DATA/overview recordings/annotations.csv'
path_st = 'ANALYSIS/DATA/selection tables'
path_functions = 'ANALYSIS/CODE/functions'

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Load data
load(path_data)
anno = read.csv2(path_anno)
st = load.selection.tables(path_st)
dat = merge(st, anno, by.x = 'Annotation', by.y = 'annotation_ref',
            all.x = T, all.y = F)

# Get ind and rec
dat$fs = paste(dat$file, dat$Selection, sep = '-')
fs = rownames(m) %>% str_remove('.wav')
files = fs %>% str_split('-') %>% sapply(`[`, 1)
inds = sapply(fs, function(x) anno$bird[anno$annotation_ref == dat$Annotation[dat$fs == x]])

# Mantel test
l = length(fs)
m_ind = matrix(NA, nrow = l, ncol = l)
for(row in 1:length(inds))
  for(col in 1:length(inds))
    m_ind[row, col] = ifelse(inds[row] == inds[col], 0, 1)
diag(m_ind) = NA
mantel_out = mantel(m, m_ind,
           method = 'pearson', permutations = 1000, 
           strata = NULL, na.rm = TRUE, parallel = 4)
cat(sprintf('The mantel test for individual signal has r = %s and p = %s.\n', 
            round(mantel_out$statistic, 3), round(mantel_out$signif, 3)))

# Partial mantel - recording+ind
m_rec_ind = matrix(NA, nrow = l, ncol = l)
for(row in 1:length(files))
  for(col in 1:length(files))
    m_rec_ind[row, col] = ifelse(files[row] == files[col] & inds[row] == inds[col], 0, 1)
diag(m_rec_ind) = NA
partial_mantel_out = mantel.partial(m, 
                    m_ind, 
                    m_rec_ind,
                    method = 'pearson', permutations = 1000, 
                    strata = NULL, na.rm = TRUE, parallel = 4)
cat(sprintf(
  'The partial mantel test for individual signal (controlling for recording) has r = %s and p = %s.\n', 
  round(partial_mantel_out$statistic, 3), round(partial_mantel_out$signif, 3)))


