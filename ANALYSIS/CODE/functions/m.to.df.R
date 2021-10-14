# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: social networks
# Date started: 24-08-2021
# Date last modified: 12-10-2021
# Author: Simeon Q. Smeele
# Description: Taking matrix with distances and making it into a dataframe that can be analysed with stan 
# model. 
# This version has the option to also include the rec level. 
# This version also calculates the time difference between recordings. 
# This version includes the time difference for the simulation .
# This version includes the option to include time between recordings.  
# This version made recordings unique per ind. 
# This version includes the option to further clean the data. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

m.to.df = function(m, 
                   inds,
                   recs = NULL,
                   time_saver = NULL,
                   day_saver = NULL,
                   progress_bar = T,
                   clean_data = F){
  
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
          rec_i = paste(recs[i], inds[i]),
          rec_j = paste(recs[j], inds[j]),
          rec_pair = paste(recs[i], inds[i], recs[j], inds[j], sep = '-')))
      }
      if(!is.null(time_saver)) new$time = c(time_saver[i], time_saver[j]) %>% diff %>% abs
      if(!is.null(day_saver)) new$date = c(day_saver[i], day_saver[j]) %>% diff %>% abs
      d = rbind(d, new)
    }
  }
  d$ind_pair = as.integer(as.factor(d$ind_pair))
  if(!is.null(recs)){
    trans_recs = seq_along(unique(c(d$rec_i, d$rec_j)))
    names(trans_recs) = unique(c(d$rec_i, d$rec_j))
    d$rec_i = trans_recs[d$rec_i]
    d$rec_j = trans_recs[d$rec_j]
    d$rec_pair = as.integer(as.factor(d$rec_pair))
  }
  if(progress_bar) close(pb)
  
  if(clean_data){
    clean_dat = as.list(d)
    clean_dat$d = as.numeric(scale(d$d))
    clean_dat$N_ind_pair = max(d$ind_pair)
    clean_dat$N_rec_pair = max(d$rec_pair)
    clean_dat$N_ind = max(d$ind_i)
    clean_dat$N_rec = max(d$rec_i)
    clean_dat$N_call = max(d$call_j)
    clean_dat$N_obs = length(d$call_i)
    clean_dat$same_ind = sapply(1:max(d$ind_pair), function(pair) # 1 = same, 0 = different
      ifelse(clean_dat$ind_i[clean_dat$ind_pair == pair][1] == 
               clean_dat$ind_j[clean_dat$ind_pair == pair][1], 1, 0))
    clean_dat$same_rec = sapply(1:max(d$rec_pair), function(pair) # 1 = same, 0 = different
      ifelse(clean_dat$rec_i[clean_dat$rec_pair == pair][1] == 
               clean_dat$rec_j[clean_dat$rec_pair == pair][1], 1, 0))
    return(clean_dat)
  } else return(d)
  
}