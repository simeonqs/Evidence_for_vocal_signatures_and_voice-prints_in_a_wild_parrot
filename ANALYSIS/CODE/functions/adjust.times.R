# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 28-01-2022
# Date last modified: 28-01-2022
# Author: Simeon Q. Smeele
# Description: Adjusts start and end times for the selection table from the traces.  
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

adjust.times = function(st, traces){
  
  traces$fs = traces$Song %>% str_remove('.wav')
  st$End.Time..s. = sapply(st$fs, function(fs)
    st$Begin.Time..s.[st$fs == fs] + max(traces$Time[traces$fs == fs])/1000)
  st$Begin.Time..s. = sapply(st$fs, function(fs)
    st$Begin.Time..s.[st$fs == fs] + min(traces$Time[traces$fs == fs])/1000)
  if(any(st$End.Time..s.-st$Begin.Time..s. > 3)) stop('Some calls are too long.')
  
  return(st)
  
}
