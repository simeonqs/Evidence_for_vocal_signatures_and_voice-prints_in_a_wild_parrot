# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: monk parakeets
# Date started: 20-10-2021
# Date last modified: 18-01-2022
# Author: Simeon Q. Smeele
# Description: Loads wave from selection table and audio file. Filters, checks for clipping. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

require(warbleR)

load.wave = function(path_audio_file, 
                     from,
                     to){
  
  wave = readWave(path_audio_file, 
                  from = as.numeric(from),
                  to = as.numeric(to),
                  units = 'seconds')
  
  if(max(abs(wave@left)) == 32768) wave@left = wave@right # if clipping use right channel
  if(max(abs(wave@left)) == 32768) warning(sprintf('Clipping in file %s!', path_audio_file))
  wave = ffilter(wave, from = 500, output = 'Wave')
  
  return(wave)
  
}