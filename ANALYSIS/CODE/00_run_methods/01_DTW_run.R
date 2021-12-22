# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 27-09-2021
# Date last modified: 27-09-2021
# Author: Simeon Q. Smeele
# Description: Running DTW on the traces of isolated contact calls. 
# source('ANALYSIS/CODE/dtw/00_run_dtw.R')
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# DATA ----
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('data.table', 'tidyverse', 'warbleR', 'dtw', 'parallel')
for(lib in libraries){
  if(! lib %in% installed.packages()) lapply(lib, install.packages)
  lapply(lib, require, character.only = TRUE)
}

# Clean R
rm(list=ls()) 

# Paths
path_functions = 'ANALYSIS/CODE/functions'
path_audio = 'ANALYSIS/DATA/audio'
path_selection_tables = 'ANALYSIS/DATA/selection tables'
path_annotations = 'ANALYSIS/DATA/overview recordings/annotations.csv'
path_context= 'ANALYSIS/DATA/overview recordings/call types.xlsx'
path_traces = 'ANALYSIS/DATA/luscinia/all contact.csv'
path_pdf = 'ANALYSIS/RESULTS/luscinia/traces.pdf'
path_dtw_out = 'ANALYSIS/RESULTS/luscinia/dtw/dtw_and_m.RData'

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Audio files 
audio_files = list.files(path_audio,  '*wav', full.names = T)

# Load selection tables
dat = load.selection.tables(path_selection_tables, path_annotations, path_context)

# Subset for isolated contact calls
dat = dat[dat$`call type` == 'contact',]
dat = dat[dat$context %in% c('isolated', 'response'),]

# Load traces
traces = read.csv(path_traces)
message(sprintf('Loaded traces from %s call type(s) with a total of %s clips.', 
                length(unique(traces$Individual)),
                length(unique(traces$Song))))

# Clean traces
traces = traces[!(traces$Song == '2020_11_16_121650-104.wav' & traces$Element == 1),]
traces = traces[!(traces$Song == '2020_11_09_083040-4.wav' & traces$Element == 2),]
traces = traces[!(traces$Song == '2020_11_09_083040-4.wav' & traces$Element == 3),]
traces = traces[!(traces$Song == '2020_10_27_091634-63.wav' & traces$Element == 2),]
traces = traces[!(traces$Song == '2020_11_01_170724-3.wav' & traces$Element == 2),]
traces = traces[!(traces$Song == '2020_11_07_101750-11.wav' & traces$Element == 2),]

# Subset traces
traces = traces[str_remove(traces$Song, '.wav') %in% dat$fs,]

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# ANALYSIS: analyse traces ----
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# *** Plot traces on spectrogram ----
message('Starting plotting.')
pdf(path_pdf)
for(file_sel in unique(traces$Song)){
  
  # Subset
  sub = traces[traces$Song == file_sel,]
  sub_dat = dat[dat$fs == str_remove(file_sel, '.wav'),]
  
  # Plot spectrogram
  better.spectro(readWave(paste0(path_audio, '/', sub_dat$file, '.wav'),
                          from = sub_dat$Begin.Time..s.,
                          to = sub_dat$End.Time..s.,
                          units = 'seconds'),
                 ylim = c(0, 10000), main = file_sel)
  
  # Plot trace
  lines(sub$Time/1000 + 256/44100/2, 
        sub$Fundamental_frequency, lwd = 3, col = 4)
  
}
dev.off()

# *** Run SCC and DTW ----

# Extract traces and smoothen
message('Starting smoothening traces.')
set.seed(1)
file_sels = sample(unique(traces$Song)) # randomise order
traces_smooth = mclapply(file_sels, function(file_sel){
  trace = traces$Fundamental_frequency[traces$Song == file_sel]
  new_trace = smooth.spline(trace, spar = 0.3) %>% fitted
  return(new_trace)
}, mc.cores = 4)

# Length of the original data
l = length(traces_smooth)

# Combinations
c = combn(1:l, 2)

# Running through the combinations -  DTW
message('Starting dtw.')
dtw_outs = mclapply(1:ncol(c), function(x) {
  
  i = c[1,x]
  j = c[2,x]
  dtw_out = dtw(traces_smooth[[i]], traces_smooth[[j]])
  return( dtw_out$normalizedDistance )
  
}, mc.cores = 4) %>% unlist # End running through the combinations
dtw_outs_with_names = list(dtw_outs = dtw_outs, file_sels = file_sels)

# Making it into a matrix
l = length(dtw_outs_with_names$file_sels)
o = dtw_outs_with_names$dtw_outs
o = o / max(o)
o = log(o)
hist(o)
m = o.to.m(o, file_sels)
file_sels = dtw_outs_with_names$file_sels %>% str_remove('.wav')
rownames(m) = colnames(m) = file_sels

# Save
save(dtw_outs_with_names, m, file = path_dtw_out)

# Report
message(sprintf('Saved dtw results for %s calls.', length(file_sels)))