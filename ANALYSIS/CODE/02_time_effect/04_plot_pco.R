# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 01-05-2022
# Date last modified: 02-05-2022
# Author: Simeon Q. Smeele
# Description: Plotting some recordings as PCO plots.
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

# Open PDF
pdf(path_pdf_pco_plots, 10, 4.5)
par(mfrow = c(2, 5), mar = c(1, 1, 1, 1), oma = c(3, 3, 3, 1))

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
  sort(table(st_sub$file))
  sort(table(st_sub$bird[st_sub$file == file]))
  keep = rownames(m) %in% st_sub$fs[st_sub$file == file & st_sub$bird == bird]
  m_sub = m[keep, keep]
  time = st_sub$Begin.Time..s.[keep]
  time = time - min(time)
  m_sub = m_sub[order(time), order(time)]
  time = sort(time)
  
  # PCO
  pco_out = pcoa(m_sub)
  
  # Plot
  tr = round(time, -1) %>% as.factor %>% as.integer
  plot(pco_out$vectors[,1:2], type = 'b', col = tr, pch = 16, cex = 2,
       xaxt = 'n', yaxt = 'n', xlab = '', ylab = '')
  points(pco_out$vectors[1,1], pco_out$vectors[1,2], pch = 16, col = 'white')
  if(i < 6) mtext(type, 3, 1, font = 2)
  if(i > 5) mtext('axis 1', 1, 1)
  if(i %in% c(1, 6)) mtext('axis 2', 2, 1)
  
} # end i loop

# Save PDF
dev.off()


