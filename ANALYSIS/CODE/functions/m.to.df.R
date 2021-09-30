# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: social networks
# Date started: 24-08-2021
# Date last modified: 28-09-2021
# Author: Simeon Q. Smeele
# Description: Taking matrix with distances and making it into a dataframe that can be analysed with stan 
# model. 
# This version has the option to also include the rec level. 
# This version also calculates the time difference between recordings. 
# This version includes the time difference for the simulation .
# This version includes the option to include time between recordings.  
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

m.to.df = function(m, 
                   inds,
                   recs = NULL,
                   time_saver = NULL,
                   day_saver = NULL,
                   progress_bar = T){
  
  d = data.frame()
  
  if(progress_bar) pb = txtProgressBar(min = 0, max = nrow(m), initial = 0, style = 3)
  for(i in 1:nrow(m)){
    if(progress_bar) setTxtProgressBar(pb,i)
    if(i == ncol(m)) break
    for(j in (i+1):ncol(m)){
      new = data.frame(
        d = m[i,j],
        call_i = i,
        call_j = j,
        ind_i = inds[i],
        ind_j = inds[j],
        ind_pair = paste(inds[i], inds[j], sep = '-')
      )
      if(!is.null(recs)){
        new = cbind(new, data.frame(
        rec_i = recs[i],
        rec_j = recs[j],
        rec_pair = paste(recs[i], recs[j], sep = '-')))
      }
      if(!is.null(time_saver)) new$time = c(time_saver[i], time_saver[j]) %>% diff %>% abs
      if(!is.null(day_saver)) new$date = c(day_saver[i], day_saver[j]) %>% diff %>% abs
      d = rbind(d, new)
    }
  }
  d$ind_pair = as.integer(as.factor(d$ind_pair))
  if(!is.null(recs)){
    d$rec_i = as.integer(as.factor(d$rec_i))
    d$rec_j = as.integer(as.factor(d$rec_j))
    d$rec_pair = as.integer(as.factor(d$rec_pair))
  }
  if(progress_bar) close(pb)
  
  return(d)
  
}