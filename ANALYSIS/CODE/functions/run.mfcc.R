# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: monk parakeets
# Date started: 18-01-2022
# Date last modified: 25-01-2022
# Author: Simeon Q. Smeele
# Description: Runs mfcc on a wave object and ouputs a dataframe with summary stats. 
# This version adds a filter. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

require(warbleR)

run.mfcc = function(wave){
  wave = ffilter(wave, from = 500, output = 'Wave')
  melfcc_out = suppressWarnings(
    melfcc(wave, wintime = 512/44100, hoptime = 50/44100, numcep = 10, minfreq = 300)
  )
  means = melfcc_out %>% apply(2, mean)
  sds = melfcc_out %>% apply(2, sd)
  out = as.data.frame(t(means))
  names(out) = paste('V', names(out))
  return(cbind(out, as.data.frame(t(sds))))
}
  