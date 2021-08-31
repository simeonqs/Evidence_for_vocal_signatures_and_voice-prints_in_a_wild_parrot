# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: sna model
# Date started: 29-08-2021
# Date last modified: 29-08-2021
# Author: Simeon Q. Smeele
# Description: This function runs the simulation for the data that can be analysed with a social networks
# model. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

sim.sna.data = function(settings = list(N_ind = 10,
                                        N_var = 5,
                                        lambda_rec = 2,
                                        lambda_obs = 3,
                                        sigma_ind = 1,
                                        sigma_rec = 0.5,
                                        sigma_obs = 0.1),
                        plot_it = F
){
  
  # Simulate
  recs = c()
  inds = c()
  dat = data.frame()
  for(ind in 1:settings$N_ind){
    means_ind = rnorm(settings$N_var, 0, settings$sigma_ind)
    N_rec = rpois(1, settings$lambda_rec)
    if(N_rec == 0) next
    for(rec in 1:N_rec){
      means_rec = rnorm(settings$N_var, means_ind, settings$sigma_rec)
      N_obs = rpois(1, settings$lambda_obs)
      if(N_obs == 0) next
      for(obs in 1:N_obs){
        recs = c(recs, paste(ind, rec))
        inds = c(inds, ind)
        dat = rbind(dat, rnorm(settings$N_var, means_rec, settings$sigma_obs))
      }
    }
  }
  inds = as.integer(as.factor(inds))
  recs = as.integer(as.factor(recs))
  
  # Plot first two variables
  if(plot_it) plot(dat[,1], dat[,2], pch = 16, col = inds)
  
  # Make into distance matrix
  names(dat) = paste0('x', 1:ncol(dat))
  m = as.matrix(dist(dat))
  d = m.to.df(m, inds, recs)
  
  # List data
  clean_dat = as.list(d)
  clean_dat$d = as.numeric(scale(d$d)) # smaller values = closer = more similar
  clean_dat$N_ind_pair = max(d$ind_pair)
  clean_dat$N_rec_pair = max(d$rec_pair)
  clean_dat$N_ind = max(d$ind_j)
  clean_dat$N_rec = max(d$rec_j)
  clean_dat$N_call = max(d$call_j)
  clean_dat$N_obs = length(d$call_i)
  clean_dat$same_ind = sapply(1:max(d$ind_pair), function(pair) # 1 = same, 0 = different
    ifelse(clean_dat$ind_i[clean_dat$ind_pair == pair][1] == 
             clean_dat$ind_j[clean_dat$ind_pair == pair][1], 1, 0))
  clean_dat$settings = settings
  
  # Return
  return(clean_dat)
  
}