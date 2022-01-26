# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 25-01-2022
# Date last modified: 25-01-2022
# Author: Simeon Q. Smeele
# Description: Test if the spec_objects and spcc output are correct. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('tidyverse', 'oce', 'signal')
for(lib in libraries){
  if(! lib %in% installed.packages()) lapply(lib, install.packages)
  lapply(lib, require, character.only = TRUE)
}

# Clean R
rm(list=ls()) 

# Paths
source('ANALYSIS/CODE/paths.R')

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Load data
load(path_data)
load(path_spec_objects)
load(path_spcc_m_list)

# Plot most extreme case per call type
pdf(path_pdf_test_spcc, 8, 4)
par(mfrow = c(1, 2))
for(type in names(m_list)){
  m = m_list[[type]]
  rs = rowSums(m)
  the_ones = rownames(m)[order(rs, decreasing = T)][1:10]
  for(one in the_ones){
    i = which(st$fs == one)
    start = st$Begin.Time..s.[i] - 0.05
    end = st$End.Time..s.[i] + 0.05
    wave = load.wave(path_audio_file = paste0(path_audio, '/', st$file[i], '.wav'), 
                     from = start,
                     to = end)
    better.spectro(wave, main = paste(type, st$fs[i]), ylim = c(0, 6000), ovl = 400)
    abline(v = c(0.05, end-start-0.05), lty = 2, lwd = 3, col = alpha(1, 0.5))
    image(t(spec_objects[[i]]), col = hcl.colors(12, 'Blue-Yellow', rev = T)) 
  }
}
dev.off()

# Run tests
message('Running tests...')
if(length(spec_objects) != length(st$fs)) stop('Spec objects and seletction table do not match!')
if(all(names(spec_objects) != names(st$fsa))) stop('Names spec objects and seletction do not match!')

# Report success if nothing breaks
message('No problems to report. All fine.')
