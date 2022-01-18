# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 17-01-2022
# Date last modified: 17-01-2022
# Author: Simeon Q. Smeele
# Description: Fills a gap in traces by adding a straighlines to the last and first point. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

gap.filler = function(time, trace){
  new_time = seq(min(time), max(time), 0.7)
  new_trace = sapply(new_time, function(x){
    y = trace[time == x]
    ifelse(length(y) == 0, NA, y)
  })
  while(any(is.na(new_trace))){
    nas =  which(is.na(new_trace))
    start = nas[1]
    end = nas[which(diff(nas) > 1)[1]]
    if(length(end) == 0) end = start
    if(is.na(end)) end = nas[length(nas)]
    start_value = new_trace[start-1]
    end_value = new_trace[end+1]
    if(is.na(start_value)) start_value = end_value
    if(is.na(end_value)) end_value = start_value
    new_trace[start:end] = seq(start_value, end_value, length.out = 1+end-start)
  }
  return(new_trace)
}
