# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 19-10-2021
# Date last modified: 19-10-2021
# Author: Simeon Q. Smeele
# Description: Loading the datasets and running specan on all calls. Saving the distance matrices per 
# dataset. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('tidyverse', 'warbleR')
for(lib in libraries){
  if(! lib %in% installed.packages()) lapply(lib, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Clean R
rm(list=ls()) 

# Paths
path_functions = 'ANALYSIS/CODE/functions'
path_out = 'ANALYSIS/RESULTS/00_run_methods/specan/results.RData'
path_data_sets = 'ANALYSIS/RESULTS/00_run_methods/data_sets.RData'
path_audio_files = 'ANALYSIS/DATA/audio'
  
# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Load data 
load(path_data_sets)

# Specan function
specan.sim = function(dat_orig){
  
  # Redo start and end
  dat = wave.detec(dat_orig, path_audio_files)
  
  # Test if wave.detec kept all calls 
  d = dat$End.Time..s. - dat$Begin.Time..s.
  if(any(d < 0.001)) warning('Some calls might be too faint!')
  
  # Measure
  out = data.frame(fs = dat$fs)
  out$duration = d
  audio_files = list.files(path_audio_files, full.names = T)
  for(i in 1:nrow(out)){
    print(out$fs[i])
    wave = readWave(audio_files[str_detect(audio_files, dat$file[i])], 
                    from = dat$Begin.Time..s.[i],
                    to = dat$End.Time..s.[i],
                    units = 'seconds')
    if(max(abs(wave@left)) == 32768) wave@left = wave@right # if clipping use right channel
    if(max(abs(wave@left)) == 32768) warning(sprintf('Clipping in file %s!', amp_mod$nr.notes))
    wave = ffilter(wave, from = 500, output = 'Wave')
    spec_wave = spec(wave, plot = F)
    out$peak_freq_khz[i] = spec_wave[which(spec_wave[,2] == 1), 1]
    w = which(spec_wave[,2] > 0.4)
    out$low_freq_khz[i] = spec_wave[w[1], 1]
    out$high_freq_khz[i] = spec_wave[w[length(w)], 1]
    out$bw_khz[i] = spec_wave[w[length(w)], 1] - spec_wave[w[1], 1]
    amp_mod = amp.mod(wave)
    out$amp_mod_peaks[i] = amp_mod$nr.notes
    out$amp_mod_ii[i] = amp_mod$amp.mod.med
  }
  
} # end specan.sim
  
# Run specan
specan_out = lapply(data_sets, specan.sim)

# Save
save(specan_out, path_out)
message('Done.')