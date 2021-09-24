# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 22-09-2021
# Date last modified: 23-09-2021
# Author: Simeon Q. Smeele
# Description: Running mfcc per call type and saving data as long distance for SN model. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# DATA ----
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('data.table', 'tidyverse', 'warbleR')
for(i in libraries){
  if(! i %in% installed.packages()) lapply(i, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Clean R
rm(list=ls()) 
dev.off()
cat('\014')  

# Paths
path_functions = 'ANALYSIS/CODE/functions'
path_audio = 'ANALYSIS/DATA/audio'
path_selection_tables = 'ANALYSIS/DATA/selection tables'
path_annotations = 'ANALYSIS/DATA/overview recordings/annotations.csv'
path_context = 'ANALYSIS/DATA/overview recordings/call types.xlsx'
path_out = 'ANALYSIS/RESULTS/mfcc/datasets per call type'
path_call_type_classification = 'ANALYSIS/CODE/call type classification.R'

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Audio files 
audio_files = list.files(path_audio,  '*wav', full.names = T)

# Load selection tables
st = load.selection.tables(path_selection_tables, path_annotations, path_context)

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# ANALYSIS: all calls ----
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Get better start and end times
new_sel_table = wave.detec(st, path_audio, bp = 0.3)

# Test how well it worked
if(F){
  pdf('~/Desktop/test.pdf')
  set.seed(1)
  for(i in sample(seq_along(new_sel_table), 10)){
    wave = readWave(paste0(path_audio, '/', new_sel_table$file[i], '.wav'), 
                    from = new_sel_table$Begin.Time..s.[i] - 0.1, to = new_sel_table$End.Time..s.[i] + 0.1, 
                    units = 'seconds')
    better.spectro(wave)
    abline(v = 0.1, lty = 2, lwd = 3)
    abline(v = length(wave@left)/wave@samp.rate - 0.1, lty = 2, lwd = 3)
  }
  dev.off()
}

# Run mfcc
out = data.frame()
for(i in 1:nrow(new_sel_table)){
  wave = readWave(paste0(path_audio, '/', new_sel_table$file[i], '.wav'), 
                  new_sel_table$Begin.Time..s.[i], new_sel_table$End.Time..s.[i], 
                  units = 'seconds')
  melfcc_out = suppressWarnings(
    melfcc(wave, wintime = 512/44100, hoptime = 50/44100, numcep = 20, minfreq = 300)
  )
  means = melfcc_out %>% apply(2, mean)
  sds = melfcc_out %>% apply(2, sd)
  new = as.data.frame(t(means))
  names(new) = paste('V', names(new))
  new = cbind(new, as.data.frame(t(sds)))
  out = rbind(out, new)
}

# Listing the call types to include - need to include more, just starting small
source(path_call_type_classification)
if(length(unique(new_sel_table$`call type`)) != length(unique(unlist(types_include)))) 
  warning('Not all call types are included.')

# Run through them and save
for(type in names(types_include)){
  out_sub = out[new_sel_table$`call type` %in% types_include[[type]],]
  d_sub = new_sel_table[new_sel_table$`call type` %in% types_include[[type]],]
  names(d_sub)[names(d_sub) == 'bird'] = 'ind'
  m_sub = as.matrix(dist(out_sub))
  m_sub = m_sub/max(m_sub)
  save(d_sub, m_sub, file = sprintf('%s/%s.RData', path_out, type))
}
