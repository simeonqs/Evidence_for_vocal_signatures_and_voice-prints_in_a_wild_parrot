# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: monk parakeets
# Date started: 18-01-2022
# Date last modified: 03-03-2022
# Author: Simeon Q. Smeele
# Description: Creates an object with n traces. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

require(warbleR)

mfcc.object = function(wave, numcep = 10){
  wave = ffilter(wave, from = 500, output = 'Wave')
  melfcc_out = suppressWarnings(
    melfcc(wave, wintime = 512/44100, hoptime = 50/44100, numcep = numcep, minfreq = 300)
  )
  
  if(F){
    imagep(x = 1:nrow(melfcc_out), y = 1:ncol(melfcc_out), z = melfcc_out,
           ylab = 'trace',
           xlab = 'time',
           col = hcl.colors(20, "RdBu", rev = TRUE) ,
           drawPalette = F,
           decimate = F) 
  }
  
  return(t(melfcc_out))
}
  