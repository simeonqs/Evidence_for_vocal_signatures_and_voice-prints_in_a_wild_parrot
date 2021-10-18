# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 11-10-2021
# Date last modified: 12-10-2021
# Author: Simeon Q. Smeele
# Description: Visualising the results of SPCC, DTW and MFCC. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('rethinking', 'warbleR', 'MASS', 'tidyverse', 'readxl', 'umap', 'ape')
for(lib in libraries){
  if(! lib %in% installed.packages()) lapply(lib, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Clean R
rm(list=ls()) 

# Paths
path_functions = 'ANALYSIS/CODE/functions'
path_dtw = 'ANALYSIS/RESULTS/luscinia/dtw/dtw_and_m.RData'
path_spcc = 'ANALYSIS/RESULTS/spcc/o_with_names.RData'
path_mfcc = 'ANALYSIS/RESULTS/mfcc/datasets per call type/contact.RData'
path_anno = 'ANALYSIS/DATA/overview recordings/annotations.csv'
path_context = 'ANALYSIS/DATA/overview recordings/call types.xlsx'
path_st = 'ANALYSIS/DATA/selection tables'
path_pdf = 'ANALYSIS/RESULTS/00_compare_methods/umap.pdf'
path_out = 'ANALYSIS/RESULTS/00_compare_methods/objects.RData'

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Load data
load(path_dtw) # object is called: dtw_outs_with_names, m
load(path_spcc) #                  o_with_names
load(path_mfcc) #                  d_sub, m_sub
dat = load.selection.tables(path_st, path_anno, path_context)
anno = read.csv2(path_anno)

# Subset for isolated contact calls
dat = dat[dat$`call type` == 'contact',]
dat = dat[dat$context %in% c('isolated', 'response'),]

# List all names
all_names = dat$fs
dtw_names = dtw_outs_with_names$file_sels %>% str_remove('.wav')
spcc_names = o_with_names$file_sels
mfcc_names = d_sub$fs
shared_names = Reduce(intersect, list(all_names, dtw_names, spcc_names, mfcc_names))

# Get matrices
m_dtw = o.to.m(log(dtw_outs_with_names$dtw_outs) / max(log(dtw_outs_with_names$dtw_outs)), dtw_names)
m_dtw = m_dtw[shared_names, shared_names]
m_spcc = o.to.m(as.numeric(o_with_names$o), spcc_names)
m_spcc = m_spcc[shared_names, shared_names]
m_mfcc = m_sub
colnames(m_mfcc) = rownames(m_mfcc) = mfcc_names
m_mfcc = m_mfcc[shared_names, shared_names]

# Run UMAP on each matrix
umap_dtw = umap(m_dtw, input = 'dist', n_neighbors = 5, spread = 1, min_dist = 0.1)
umap_spcc = umap(m_spcc, input = 'dist', n_neighbors = 5, spread = 1, min_dist = 0.1)
umap_mfcc = umap(m_mfcc, input = 'dist', n_neighbors = 5, spread = 1, min_dist = 0.1)

# Run PCO on each matrix
colnames(m_spcc) = rownames(m_spcc) = NULL
pco_dtw = pcoa(m_dtw)
pco_spcc = pcoa(m_spcc)
pco_mfcc = pcoa(m_mfcc)

# Get colour
d_all = dat
rownames(d_all) = d_all$fs
d_all = d_all[shared_names,]
five_most = names(sort(table(d_all$bird), decreasing = T)[1:5])
col_trans = 2:6
names(col_trans) = five_most
cols = col_trans[d_all$bird]
cols[is.na(cols)] = 1

# Plot
pdf(path_pdf, 8, 5.5)
par(mfrow = c(2, 3))
plot(umap_dtw$layout, pch = 16, col = alpha(cols, ifelse(cols == 1, 0.2, 0.7)), cex = 2,
     xlab = 'UMAP 1', ylab = 'UMAP 2', main = 'DTW')
plot(umap_spcc$layout, pch = 16, col = alpha(cols, ifelse(cols == 1, 0.2, 0.7)), cex = 2,
     xlab = 'UMAP 1', ylab = 'UMAP 2', main = 'SPCC')
plot(umap_mfcc$layout, pch = 16, col = alpha(cols, ifelse(cols == 1, 0.2, 0.7)), cex = 2,
     xlab = 'UMAP 1', ylab = 'UMAP 2', main = 'MFCC')
plot(pco_dtw$vectors[,1:2], pch = 16, col = alpha(cols, ifelse(cols == 1, 0.2, 0.7)), cex = 2,
     xlab = 'PCO 1', ylab = 'PCO 2', main = 'DTW')
plot(pco_spcc$vectors[,1:2], pch = 16, col = alpha(cols, ifelse(cols == 1, 0.2, 0.7)), cex = 2,
     xlab = 'PCO 1', ylab = 'PCO 2', main = 'SPCC')
plot(pco_mfcc$vectors[,1:2], pch = 16, col = alpha(cols, ifelse(cols == 1, 0.2, 0.7)), cex = 2,
     xlab = 'PCO 1', ylab = 'PCO 2', main = 'MFCC')
dev.off()

# Save objects for later steps
save(m_dtw, m_spcc, m_mfcc, d_all, file = path_out)

# Report
message('Plotted and saved!')