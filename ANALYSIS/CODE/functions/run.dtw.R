# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 18-01-2022
# Date last modified: 27-01-2022
# Author: Simeon Q. Smeele
# Description: Running DTW for a set of smooth traces and returning a named, normalised distance matrix.
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

run.dtw = function(smooth_traces){
  
  # Run DTW
  l = length(smooth_traces)
  c = combn(1:l, 2)
  message(sprintf('Starting DTW for %s traces...', l))
  out = mclapply(1:ncol(c), function(x) {
    i = c[1,x]
    j = c[2,x]
    dtw_out = dtw(smooth_traces[[i]], smooth_traces[[j]])
    return( dtw_out$normalizedDistance )
  }, mc.cores = 4) %>% unlist # end running through the combinations
  message('Done!')
  
  # Making it into a matrix
  o = out
  o = o / max(o)
  o = log(o)
  m = o.to.m(o, names(smooth_traces))
  rownames(m) = colnames(m) = names(smooth_traces)
  
  # Return
  return(m)
}
