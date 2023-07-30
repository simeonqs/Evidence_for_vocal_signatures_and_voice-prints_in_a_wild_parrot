# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 26-03-2023
# Date last modified: 26-03-2023
# Author: Simeon Q. Smeele
# Description: Creating PCA plot for supplementals.
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('cmdstanr', 'rstan', 'rethinking', 'tidyverse')
for(lib in libraries){
  if(! lib %in% installed.packages()) lapply(lib, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Clean R
rm(list=ls()) 
set.seed(1)

# Paths
source('ANALYSIS/CODE/paths.R')

# Load data
load(path_data)
load(path_spcc_m_list)
rownames(st) = st$fs

# Plot PCA per call type. 
pdf(path_pdf_pca, 10, 2.5)
par(mfrow = c(1, 5))
for(type in c('contact', 'tja', 'trruup', 'alarm', 'growl')){
  m = m_list[[type]]
  inds = st[colnames(m),]$bird
  recs = st[colnames(m),]$file
  sub_inds = sample(unique(inds), 5)
  pca_out = princomp(m[inds %in% sub_inds, inds %in% sub_inds])
  plot(pca_out$scores[,1:2], pch = as.integer(as.factor(recs[inds %in% sub_inds])), 
       col = as.integer(as.factor(inds[inds %in% sub_inds])),
       main = type)
}
dev.off()
