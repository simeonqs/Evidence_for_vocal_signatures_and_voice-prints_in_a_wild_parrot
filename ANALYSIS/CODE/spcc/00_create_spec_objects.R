# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: chapter II
# Date started: 22-02-2021
# Date last modified: 28-05-2021
# Author: Simeon Q. Smeele
# Description: Writing my own script to generate spectrograms and compare pixel by pixel using sliding
# window. 
# This version works for the alarm calls from 2020. This is a new version using the context file. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# DATA ----
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('data.table', 'tidyverse', 'seewave', 'tuneR', 'signal', 'parallel', 'umap', 'vegan')
for(i in libraries){
  if(! i %in% installed.packages()) lapply(i, install.packages)
  lapply(libraries, require, character.only = TRUE)
}
library(oce)
library(labdsv)

# Clean R
rm(list=ls()) 
dev.off()
cat('\014')  

# Set working directory to mother-folder
setwd(str_remove(dirname(rstudioapi::getActiveDocumentContext()$path), '/CODE'))

# Import functions
.functions = sapply(list.files('CODE/functions', pattern = '*R', full.names = T), source)

# Audio files 
path_audio = 'DATA/audio'
audio_files = list.files(path_audio,  '*wav', full.names = T)

# Load selection tables
dat = load.selection.tables('DATA/selection tables')

# Merge annotations
annotations = read.csv2('DATA/overview recordings/annotations.csv')
dat = merge(dat, annotations, by.x = 'Annotation', by.y = 'annotation_ref',
            all.x = T, all.y = F)

# Include types and subset
context = load.call.type.context('DATA/overview recordings/call types.xlsx')
pasted = paste0(str_remove(context$file, '.Table.1.selections.txt'), '-', context$selection)
isolated_alarm = pasted[context$`call type` == 'alarm' & context$context %in% c('isolated', 'response')]
dat$file_sel = paste(dat$file, dat$Selection, sep = '-')
dat = dat[dat$file_sel %in% isolated_alarm,]

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# ANALYSIS: similarity ----
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Generate spec_ojects
spec_objects = sapply(1:nrow(dat), function(i){
  new_dat = dat[i,]
  file = audio_files[str_detect(audio_files, new_dat$file)]
  wave = readWave(file, from = new_dat$Begin.Time..s., to = new_dat$End.Time..s., units = 'seconds')
  if(max(abs(wave@left)) == 32768) wave@left = wave@right # if clipping use right channel
  wave = ffilter(wave, from = 500, output = 'Wave')
  spec_oject = cutted.spectro(wave, freq_range = c(1000, 6000), plot_it = F, 
                              thr_low = 1.1, thr_high = 1.8,
                              wl = 512, ovl = 450, 
                              method = 'sd',
                              sum_one = T)
  return(spec_oject)
})

# Test examples
{
par(mfrow = c(2, 2))
i = 1
j = 20
better.spectro(readWave(paste0(path_audio, '/', dat$file[i], '.wav'), 
                        from = dat$Begin.Time..s.[i], 
                        to = dat$End.Time..s.[i], 
                        units = 'seconds') %>% ffilter(from = 500, output = 'Wave'), 
               xlim = c(0, 0.35), main = dat$file_sel[i], wl = 512, ovl = 450,
               ylim = c(0, 10000))
image(t(spec_objects[[i]]), col = hcl.colors(12, 'Blue-Yellow', rev = T)) 
better.spectro(readWave(paste0(path_audio, '/', dat$file[j], '.wav'), 
                        from = dat$Begin.Time..s.[j], 
                        to = dat$End.Time..s.[j], 
                        units = 'seconds') %>% ffilter(from = 500, output = 'Wave'), 
               xlim = c(0, 0.35), main = dat$file_sel[j], wl = 512, ovl = 450,
               ylim = c(0, 10000))
image(t(spec_objects[[j]]), col = hcl.colors(12, 'Blue-Yellow', rev = T)) 
}

# Save spec_objects for cluster
save(spec_objects, file = 'RESULTS/pixel comparison/spec_objects - alarm.RData')

# Get combinations and run function
c = combn(1:length(spec_objects), 2)
o = mclapply(1:ncol(c), function(i) sliding.pixel.comparison(spec_objects[[c[1,i]]], 
                                                             spec_objects[[c[2,i]]],
                                                             step_size = 1), 
             mc.cores = 4) %>% unlist
o = o/max(o)
save(o, file = 'RESULTS/pixel comparison/o - alarm.RData')

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# ANALYSIS: clustering visualisation ----
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Create matrix
m = matrix(nrow = length(spec_objects), ncol = length(spec_objects))
m[lower.tri(m)] = o
md = as.dist(m)
m[upper.tri(m)] = t(m)[upper.tri(m)]
diag(m) = 0

# Plot closest spectrogram
pdf('RESULTS/pixel comparison/closest neighbours - alarm.pdf', 7, 4)
par(mfrow = c(2, 2))
for(i in sample(1:length(spec_objects), 30)){
  j = which(m[i,] == min(m[i,-i], na.rm = T))
  better.spectro(readWave(paste0(path_audio, '/', dat$file[i], '.wav'), 
                          from = dat$Begin.Time..s.[i], 
                          to = dat$End.Time..s.[i], 
                          units = 'seconds'), 
                 xlim = c(0 , 0.5), ylim = c(0, 10000), main = m[i,j])
  better.spectro(readWave(paste0(path_audio, '/', dat$file[j], '.wav'), 
                          from = dat$Begin.Time..s.[j], 
                          to = dat$End.Time..s.[j], 
                          units = 'seconds'), 
                 xlim = c(0 , 0.5), ylim = c(0, 10000))
  image(t(spec_objects[[i]]), col = hcl.colors(12, 'Blue-Yellow', rev = T)) 
  image(t(spec_objects[[j]]), col = hcl.colors(12, 'Blue-Yellow', rev = T)) 
}
dev.off()

# Five birds
t_bird = table(dat$bird)
five_birds = sort(t_bird, decreasing = T)[1:5] %>% names
col_bird = 
  ifelse(dat$bird == five_birds[1], 2, 
         ifelse(dat$bird == five_birds[2], 3,
                ifelse(dat$bird == five_birds[3], 4, 
                       ifelse(dat$bird == five_birds[4], 5,
                              ifelse(dat$bird == five_birds[5], 6, 1)))))

# UMAP
umap_out = umap(m, input = 'dist', n_neighbors = 5, spread = 1, min_dist = 0.1)
par(mfrow = c(1, 1))
plot(umap_out$layout[,1], umap_out$layout[,2], pch = 16, col = col_bird)
idents = identify(umap_out$layout[,1], umap_out$layout[,2], order = T)

# t-SNE
t = tsne(md, perplexity = 10)
plot(t$points[,1], t$points[,2], pch = 16, col = col_bird)
idents = identify(t$points[,1], t$points[,2], order = T)

# Test arranging plots
{
  x = umap_out$layout[,1]
  y = umap_out$layout[,2]
  # x = t$points[,1]
  # y = t$points[,2]
  idents = idents$ind[order(idents$order)]
  pdf('~/Desktop/test.pdf', 10, 10)
  par(fig = c(0.25, 0.75, 0.25, 0.75), mar = rep(0, 4))
  plot(x, y, pch = 16, col = col_bird,
       xaxt = 'n', yaxt = 'n', xlab = '', ylab = '')
  umap_x_range = max(x) - min(x)
  umap_y_range = max(y) - min(y)
  for(i in 1:12){
    if(i == 1) corners = c(1.05, -0.05)
    if(i == 2) corners = c(0.67, -0.05)
    if(i == 3) corners = c(0.33, -0.05)
    if(i == 4) corners = c(-0.05, -0.05)
    if(i == 5) corners = c(-0.05, 0.33)
    if(i == 6) corners = c(-0.05, 0.67)
    if(i == 7) corners = c(-0.05, 1.05)
    if(i == 8) corners = c(0.33, 1.05)
    if(i == 9) corners = c(0.67, 1.05)
    if(i == 10) corners = c(1.05, 1.05)
    if(i == 11) corners = c(1.05, 0.33)
    if(i == 12) corners = c(1.05, 0.67)
    lines(c(x[idents[i]], min(x) + corners[1] * umap_x_range),
          c(y[idents[i]], min(y) + corners[2] * umap_y_range))
  }
  for(i in 1:12){
    if(i == 1) corners = c(0.75, 1,   0, 0.25)
    if(i == 2) corners = c(0.5, 0.75, 0, 0.25)
    if(i == 3) corners = c(0.25, 0.5, 0, 0.25)
    if(i == 4) corners = c(0.0, 0.25, 0, 0.25)
    if(i == 5) corners = c(0.0, 0.25, 0.25, 0.5)
    if(i == 6) corners = c(0.0, 0.25, 0.5, 0.75)
    if(i == 7) corners = c(0.0, 0.25, 0.75, 1)
    if(i == 8) corners = c(0.25, 0.5, 0.75, 1)
    if(i == 9) corners = c(0.5, 0.75, 0.75, 1)
    if(i == 10) corners = c(0.75, 1,  0.75, 1)
    if(i == 11) corners = c(0.75, 1,  0.5, 0.75)
    if(i == 12) corners = c(0.75, 1,  0.25, 0.5)
    par(fig = c(corners[1], corners[2], corners[3], corners[4]), new = TRUE, mar = rep(0, 4))
    better.spectro(readWave(paste0(path_audio, '/', dat$file[idents[i]], '.wav'), 
                            from = dat$Begin.Time..s.[idents[i]], 
                            to = dat$End.Time..s.[idents[i]], 
                            units = 'seconds'), 
                   xlim = c(0 , 0.5), wl = 256, ovl = 250)
    
  }
  dev.off()
}

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# ANALYSIS: mantel test ----
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Create matrix
m = matrix(nrow = length(spec_objects), ncol = length(spec_objects))
m[lower.tri(m)] = o
md = as.dist(m)
m[upper.tri(m)] = t(m)[upper.tri(m)]
diag(m) = 0

# Mantel test
l = length(dat$file_sel)
inds = dat$bird
m_ind = matrix(NA, nrow = l, ncol = l)
for(row in 1:length(inds))
  for(col in 1:length(inds)){
    m_ind[row, col] = ifelse(inds[row] == inds[col], 0, 1)
  }
diag(m_ind) = NA
mantel(m, m_ind,
       method = 'pearson', permutations = 1000, 
       strata = NULL, na.rm = TRUE, parallel = 4)

# Partial mantel - recording
recs = dat$file_sel %>% strsplit('-') %>% sapply(`[`, 1)
m_rec = matrix(NA, nrow = l, ncol = l)
for(row in 1:length(recs))
  for(col in 1:length(recs)){
    m_rec[row, col] = ifelse(recs[row] == recs[col], 0, 1)
  }
diag(m_rec) = NA
mantel.partial(m, 
               m_ind, 
               m_rec,
               method = 'pearson', permutations = 1000, 
               strata = NULL, na.rm = TRUE, parallel = 4)

# Partial mantel - recording+ind
m_rec_ind = matrix(NA, nrow = l, ncol = l)
for(row in 1:length(recs))
  for(col in 1:length(recs))
    m_rec_ind[row, col] = ifelse(recs[row] == recs[col] & inds[row] == inds[col], 0, 1)
diag(m_rec_ind) = NA
mantel.partial(m, 
               m_ind, 
               m_rec_ind,
               method = 'pearson', permutations = 1000, 
               strata = NULL, na.rm = TRUE, parallel = 4)

