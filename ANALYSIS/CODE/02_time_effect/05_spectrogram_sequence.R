# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 21-05-2022
# Date last modified: 21-05-2022
# Author: Simeon Q. Smeele
# Description: Plotting spectrogra associated with the PCO sequences. 
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
load(path_spcc_m_list)
load(path_waves)

# Open PDF
pdf(path_spec_seq, 10, 6)

# Run through plots
for(i in 1:10){
  
  # Subset
  file = c('2021_11_03_130548', '2021_11_07_104404', '2020_11_07_142224', '2021_11_09_135758', 
           '2020_11_07_165224', '2020_11_07_093536', '2020_11_10_152434', '2021_11_05_140230', 
           '2020_10_30_084352', '2021_11_06_093058')[i]
  bird = c('U45', 'U87', 'I87', 'U74', 'S32', 'T99', 'S15', 'U84', 'L22', 'U20')[i]
  type = c('contact', 'tja', 'trruup', 'alarm', 'growl', 'contact', 'tja', 'trruup', 'alarm', 'growl')[i]
  m = m_list[[type]]
  n = rownames(m)
  st_sub = st[st$fs %in% n,]
  keep = rownames(m) %in% st_sub$fs[st_sub$file == file & st_sub$bird == bird]
  st_sub = st_sub[keep,]
  
  # Plot spectrograms
  par(mfrow = c(3, 5))
  time = st_sub$Begin.Time..s.
  time = time - min(time)
  st_sub = st_sub[order(time),]
  time = sort(time)
  tr = round(time, -1) %>% as.factor %>% as.integer
  for(j in 1:nrow(st_sub)){
    better.spectro(waves[[st_sub$fs[j]]], xlim = c(0, 0.15), ylim = c(0, 15000))
    box(col = tr[j], lwd = 2)
  } 
  
} # end i loop


# Save PDF
dev.off()


