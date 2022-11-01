# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: social networks
# Date started: 24-08-2021
# Date last modified: 09-03-2022
# Author: Simeon Q. Smeele
# Description: Taking matrix with distances and making it into a dataframe that can be analysed with stan 
# model. 
# This version has the option to also include the rec level. 
# This version also calculates the time difference between recordings. 
# This version includes the time difference for the simulation .
# This version includes the option to include time between recordings.  
# This version made recordings unique per ind. 
# This version includes the option to further clean the data. 
# This version has the time difference on a log_10 scale rather than natural. 
# This version uses mclapply with four threads rather than two for loops. 
# This version includes an option to have year difference saved. 
# This version works for data from both years combined. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

require(parallel)

m.to.df = function(m, 
                   inds,
                   recs = NULL,
                   time_saver = NULL,
                   day_saver = NULL,
                   year_saver = NULL,
                   clean_data = F){
  
  l = nrow(m)
  c = combn(1:l, 2)
  d = mclapply(1:ncol(c), function(x) {
    
    new = data.frame(
      d = m[c[1,x],c[2,x]],
      call_i = c[1,x],
      call_j = c[2,x],
      ind_i = inds[c[1,x]],
      ind_j = inds[c[2,x]],
      ind_pair = paste(inds[c[1,x]], inds[c[2,x]], sep = '-')
    )
    if(!is.null(recs)){
      new = cbind(new, data.frame(
        rec_i = paste(recs[c[1,x]], inds[c[1,x]]),
        rec_j = paste(recs[c[2,x]], inds[c[2,x]]),
        rec_pair = paste(recs[c[1,x]], recs[c[2,x]])))
    }
    if(!is.null(time_saver)) new$time = c(time_saver[c[1,x]], time_saver[c[2,x]]) %>% diff %>% abs %>% log10
    if(!is.null(day_saver)) new$date = c(day_saver[c[1,x]], day_saver[c[2,x]]) %>% diff %>% abs
    if(!is.null(year_saver)) new$year = c(year_saver[c[1,x]], year_saver[c[2,x]]) %>% diff %>% abs
    
    return(new)
    
  }, mc.cores = 4) %>% bind_rows # end running through the combinations
  
  if(!is.null(recs)){
    year_1 = d$rec_pair %>% str_split(' ') %>% sapply(`[`, 2) %>% str_split('_') %>% sapply(`[`, 1)
    year_2 = d$rec_pair %>% str_split(' ') %>% sapply(`[`, 4) %>% str_split('_') %>% sapply(`[`, 1)
    d = d[year_1 == year_2,]
    trans_recs = seq_along(unique(c(d$rec_i, d$rec_j)))
    names(trans_recs) = unique(c(d$rec_i, d$rec_j))
    d$rec_i = trans_recs[d$rec_i]
    d$rec_j = trans_recs[d$rec_j]
    d$rec_pair = as.integer(as.factor(d$rec_pair))
  }
  d$ind_pair = as.integer(as.factor(d$ind_pair))
  
  # Test if across years still occurs
  if(!is.null(day_saver)) stop('Going across years.')

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