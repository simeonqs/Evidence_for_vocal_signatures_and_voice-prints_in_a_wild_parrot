# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: monk parakeets
# Date started: 18-01-2022
# Date last modified: 07-05-2022
# Author: Simeon Q. Smeele
# Description: Runs mfcc on a wave object and ouputs a dataframe with summary stats. 
# This version adds a filter. 
# This version includes the option to calculate delta MFCCs.
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

require(warbleR)

run.mfcc = function(wave, numcep = 10, incl_deltas = T){
  wave = ffilter(wave, from = 500, output = 'Wave')
  melfcc_out = suppressWarnings(
    melfcc(wave, wintime = 512/44100, hoptime = 50/44100, numcep = numcep, minfreq = 300)
  )
  means = melfcc_out %>% apply(2, mean)
  sds = melfcc_out %>% apply(2, sd)
  out = as.data.frame(t(means))
  names(out) = str_replace(names(out), 'V', 'means_')
  new = as.data.frame(t(sds))
  names(new) = str_replace(names(new), 'V', 'sds_')
  out = cbind(out, new)
  if(incl_deltas){
    delta_means = melfcc_out %>% apply(2, diff) %>% apply(2, mean)
    new = as.data.frame(t(delta_means))
    names(new) = str_replace(names(new), 'V', 'delta_means_')
    out = cbind(out, new)
  } 
  return(out)
}
  