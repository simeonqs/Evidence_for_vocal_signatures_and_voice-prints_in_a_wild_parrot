# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 19-01-2022
# Date last modified: 19-01-2022
# Author: Simeon Q. Smeele
# Description: Spectral measurements. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

specan.sim = function(wave){
  
  # Measure
  out = data.frame(duration = length(wave@left)/wave@samp.rate)
  spec_wave = spec(wave, plot = F)
  out$peak_freq_khz = spec_wave[which(spec_wave[,2] == 1), 1]
  w = which(spec_wave[,2] > 0.4)
  out$low_freq_khz = spec_wave[w[1], 1]
  out$high_freq_khz = spec_wave[w[length(w)], 1]
  out$bw_khz = spec_wave[w[length(w)], 1] - spec_wave[w[1], 1]
  amp_mod = amp.mod(wave)
  out$amp_mod_peaks = amp_mod$nr.notes
  out$amp_mod_ii = amp_mod$amp.mod.med
  
  return(out)
  
} 
