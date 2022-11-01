# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 18-03-2022
# Date last modified: 18-03-2022
# Author: Simeon Q. Smeele
# Description: Calculating Beechers H. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('tidyverse', 'ape')
for(lib in libraries){
  if(! lib %in% installed.packages()) lapply(lib, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Clean R
rm(list=ls()) 

# Paths
source('ANALYSIS/CODE/paths.R')

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Load data
load(path_data)
load(path_dtw_m_list)

# Subset
set.seed(1)
type = 'contact'
st$bird_rec = paste(st$bird, st$file)
keep = sapply(unique(st$bird_rec), function(x) sample(st$fs[st$bird_rec == x], 1))
st_sub = st[st$fs %in% keep,]
source(path_call_type_classification)
st_sub = st_sub[st_sub$`call type` %in% types_include[[type]],]
tab = table(st_sub$bird)
n = 10
bk = names(tab[tab>n])
st_sub = st_sub[st_sub$bird %in% bk,]
keep = unlist(sapply(unique(st_sub$bird), function(x) sample(st_sub$fs[st_sub$bird == x], n)))
st_sub = st_sub[st_sub$fs %in% keep,]
m = m_list[[type]]
m = m[rownames(m) %in% st_sub$fs, colnames(m) %in% st_sub$fs]

# Run PCA
pca_out = princomp(m)

# Run ANOVA
aov_out_1 = aov(pca_out$loadings[,1] ~ st[rownames(m),]$bird)
aov_out_2 = aov(pca_out$loadings[,2] ~ st[rownames(m),]$bird)
aov_out_3 = aov(pca_out$loadings[,3] ~ st[rownames(m),]$bird)

# Run Beecher
calc.beecher = function(aov_out){
  s = summary(aov_out)
  f = s[[1]]$`F value`[1]
  return(log2(sqrt((f+n-1)/n)))
}
sum(sapply(list(aov_out_1, aov_out_2, aov_out_3), calc.beecher))


# Try package
library(IDmeasurer)
dat_in = data.frame(id = st[rownames(m),]$bird, 
                    pca_1 = pca_out$loadings[,1], 
                    pca_2 = pca_out$loadings[,2], 
                    pca_3 = pca_out$loadings[,3])

# Try PCO
pco_out = pcoa(m)
dat_in = data.frame(id = st[rownames(m),]$bird, 
                    pco_1 = pco_out$vectors[,1], 
                    pco_2 = pco_out$vectors[,2], 
                    pco_3 = pco_out$vectors[,3])
calcHS(dat_in, sumHS=F)


