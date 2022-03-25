# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: sn model
# Date started: 24-09-2021
# Date last modified: 21-10-2021
# Author: Simeon Q. Smeele
# Description: This function runs the simulation for the data that can be analysed with a social networks
# model and includes time. 
# This version also includes the rec level. 
# This version adds time between recordings. 
# This version includes an option to subset the data after simulation.
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

sim.sn.data.time = function(settings = list(N_ind = 3,
                                            N_var = 2,
                                            lambda_obs = 2,
                                            lambda_rec = 10,
                                            sigma_ind = 1,
                                            sigma_obs = 0.05,
                                            sigma_rec = 0.1,
                                            slope_time = 0.00,
                                            slope_day = 0.05,
                                            dur_rec = 20,
                                            dur_dates = 20,
                                            N_sub = NULL),
                            plot_it = F
){
  
  # Simulate
  inds = c()
  dat = data.frame()
  time_saver = c()
  day_saver = c()
  recs = c()
  for(ind in 1:settings$N_ind){
    means_ind = rnorm(settings$N_var, 0, settings$sigma_ind)
    N_rec = rpois(1, settings$lambda_rec)
    if(N_rec == 0) next
    days = sort(round(runif(N_rec, 0, settings$dur_dates)))
    for(rec in 1:N_rec){
      if(rec > 1)
        means_ind = means_ind + 
          settings$slope_day * (days[rec] - days[rec-1]) * rnorm(settings$N_var, 0, 1)
      means_rec = rnorm(settings$N_var, means_ind, settings$sigma_rec)
      N_obs = rpois(1, settings$lambda_obs)
      if(N_obs == 0) next
      times = sort(runif(N_obs, 0, settings$dur_rec))
      for(obs in 1:N_obs){
        inds = c(inds, ind)
        recs = c(recs, paste(ind, rec))
        if(obs > 1){
          means_rec = means_rec + 
            settings$slope_time * (times[obs] - times[obs-1]) * rnorm(settings$N_var, 0, 1)
        }
        dat = rbind(dat, 
                    rnorm(settings$N_var, means_rec, settings$sigma_obs))
        time_saver = c(time_saver, times[obs])
        day_saver = c(day_saver, days[rec])
      } # end obs loop
    } # end rec loop
  } # end ind loop
  
  # Plot first two variables
  plot(dat[,1], dat[,2], pch = 16 + as.numeric(str_sub(recs, 3, 3)), 
       col = alpha(inds, time_saver/20))
  
  # Make into distance matrix
  inds = as.integer(as.factor(inds))
  recs = as.integer(as.factor(recs))
  names(dat) = paste0('x', 1:ncol(dat))
  m = as.matrix(dist(dat))
  if(settings$N_sub > nrow(m)) stop('Cannot take a larger subset than sample. Simulate more data.')
  if(is.null(settings$N_sub)) subber = sample(nrow(m)) else subber = sample(nrow(m), settings$N_sub)
  d = m.to.df(m[subber, subber], inds[subber], recs[subber], 
              time_saver = time_saver[subber], day_saver = day_saver[subber])
  
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
  clean_dat$same_rec = sapply(1:max(d$rec_pair), function(pair) # 1 = same, 0 = different
    ifelse(clean_dat$rec_i[clean_dat$rec_pair == pair][1] == 
             clean_dat$rec_j[clean_dat$rec_pair == pair][1], 1, 0))
  clean_dat$settings = settings
  
  # Return
  return(clean_dat)
  
}