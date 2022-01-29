# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: monk parakeets
# Date started: 21-10-2021
# Date last modified: 29-01-2022
# Author: Simeon Q. Smeele
# Description: Prepares the clean_dat for the date model. Subsets to different recordings, but same ind.
# This version has date in day rather than month. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

prep.dat.dates = function(clean_dat,
                          plot_it = F){
  
  subber = which(clean_dat$same_rec[clean_dat$rec_pair] == 0 & clean_dat$same_ind[clean_dat$ind_pair] == 1)
  if(length(subber) == 0) return(NA) else {
    if(any(clean_dat$ind_i[subber] != clean_dat$ind_j[subber])) stop('Problem subsetting!')
    sub_dat = list(call_i = clean_dat$call_i[subber] %>% as.factor %>% as.integer,
                   call_j = clean_dat$call_j[subber] %>% as.factor %>% as.integer,
                   rec_pair = clean_dat$rec_pair[subber] %>% as.factor %>% as.integer,
                   ind = clean_dat$ind_i[subber] %>% as.factor %>% as.integer,
                   date = clean_dat$date[subber],
                   d = clean_dat$d[subber] %>% scale %>% as.numeric,
                   N_obs = length(subber),
                   N_call = length(unique(c(clean_dat$call_i[subber],
                                            clean_dat$call_j[subber]))),
                   N_rec_pair = length(unique(clean_dat$rec_pair[subber])),
                   N_ind = length(unique(clean_dat$ind_i[subber])),
                   settings = clean_dat$settings)
    sub_dat$date_per_rec = sapply(seq_along(unique(sub_dat$rec_pair)), 
                                  function(x) sub_dat$date[sub_dat$rec_pair == x][1])
    sub_dat$ind_per_rec = sapply(seq_along(unique(sub_dat$rec_pair)), 
                                 function(x) sub_dat$ind[sub_dat$rec_pair == x][1])
    }
  if(plot_it) plot(sub_dat$date, sub_dat$d, col = sub_dat$ind)
  return(sub_dat)
  
}
