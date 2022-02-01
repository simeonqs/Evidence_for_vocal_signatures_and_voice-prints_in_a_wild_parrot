# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 28-01-2022
# Date last modified: 30-01-2022
# Author: Simeon Q. Smeele
# Description: Fills gaps and smoothens traces for DTW. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

smooth.traces = function(traces){
  message(sprintf('Starting the smoothening of %s traces...', length(unique(traces$Song))))
  calls = unique(traces$Song)
  smooth_traces = mclapply(calls, function(call){
    trace = traces$Fundamental_frequency[traces$Song == call]
    time = traces$Time[traces$Song == call]
    fit = gap.filler(time, trace)
    new_trace = smooth.spline(fit, spar = 0.1) %>% fitted
    return(new_trace)
  }, mc.cores = 4)
  names(smooth_traces) = str_remove(calls, '.wav')
  return(smooth_traces)
  message('Done.')
}
