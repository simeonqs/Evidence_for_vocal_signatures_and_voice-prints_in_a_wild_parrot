# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 22-03-2023
# Date last modified: 22-03-2023
# Author: Simeon Q. Smeele
# Description: Code to make boxplot of within vs between individual similarity
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('cmdstanr', 'rstan', 'rethinking', 'tidyverse')
for(lib in libraries){
  if(! lib %in% installed.packages()) lapply(lib, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Clean R
rm(list=ls()) 

# Paths
source('ANALYSIS/CODE/paths.R')

# Load data
load(path_data)

# Function to run single model
plot.figure.sim = function(m, st, type){
  
  # Prep data
  set.seed(1)
  n = rownames(m)
  subber = sample(length(n), min(c(1000, length(n))))
  inds = st[n,]$bird[subber] %>% as.factor %>% as.integer
  recs = paste(st[n,]$bird[subber], st[n,]$file[subber]) %>% as.factor %>% as.integer
  m =  m[subber, subber]
  
  # Make vectors
  ## acoustic distance
  clean_dat = data.frame(acc_dist = as.vector(as.dist(m)))
  ## getting dimensions
  l = nrow(m)
  c = combn(1:l, 2)
  ## call
  clean_dat$call_i = c[1,]
  clean_dat$call_j = c[2,]
  ## same ind = 1, else = 2
  clean_dat$same_ind = sapply(1:ncol(c), function(x) ifelse(inds[c[1,x]] == inds[c[2,x]], 1, 2))
  ## same rec = 1, else = 2
  clean_dat$same_rec = sapply(1:ncol(c), function(x) ifelse(recs[c[1,x]] == recs[c[2,x]], 1, 2))
  ## ind pair
  clean_dat$ind_pair = sapply(1:ncol(c), function(x) 
    paste(sort(c(inds[c[1,x]], inds[c[2,x]])), collapse = ' ')) %>% as.factor() %>% as.integer()
  ## rec pair
  clean_dat$rec_pair = sapply(1:ncol(c), function(x) 
    paste(sort(c(recs[c[1,x]], recs[c[2,x]])), collapse = ' ')) %>% as.factor() %>% as.integer()
  
  # Remove across years
  year_1 = paste(st[n,]$bird[subber], st[n,]$file[subber])[c[1,]] %>% str_split(' ') %>% sapply(`[`, 2) %>% 
    str_split('_') %>% sapply(`[`, 1)
  year_2 = paste(st[n,]$bird[subber], st[n,]$file[subber])[c[2,]] %>% str_split(' ') %>% sapply(`[`, 2) %>% 
    str_split('_') %>% sapply(`[`, 1)
  clean_dat = clean_dat[year_1 == year_2,]
  clean_dat$ind_pair = as.integer(as.factor(clean_dat$ind_pair))
  clean_dat$rec_pair = as.integer(as.factor(clean_dat$rec_pair))
  
  # Plot
  boxplot(clean_dat$acc_dist[clean_dat$same_ind == 1 & clean_dat$same_rec == 2],
          clean_dat$acc_dist[clean_dat$same_ind == 2 & clean_dat$same_rec == 2],
          names = c('same', 'different'), main = type)
  
}

# Plot
load(path_spcc_m_list)
pdf(path_pdf_boxplot, 10, 3)
par(mfrow = c(1, 5))
plot.figure.sim(m = m_list$contact, st = st, type = 'contact')
plot.figure.sim(m = m_list$tja, st = st, type = 'tja')
plot.figure.sim(m = m_list$trruup, st = st, type = 'trruup')
plot.figure.sim(m = m_list$alarm, st = st, type = 'alarm')
plot.figure.sim(m = m_list$growl, st = st, type = 'growl')
dev.off()
