# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 21-03-2022
# Date last modified: 21-03-2022
# Author: Simeon Q. Smeele
# Description: Simulating data for dates. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

sim.vsrm.data.dates = function(settings = list(N_ind = 3,
                                              N_var = 2,
                                              lambda_obs = 2,
                                              lambda_rec = 10,
                                              sigma_ind = 1,
                                              sigma_obs = 0.05,
                                              sigma_rec = 0.1,
                                              slope_time = 0.00,
                                              slope_day = 0.00,
                                              dur_rec = 20,
                                              dur_dates = 20),
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
  if(plot_it) plot(dat[,1], dat[,2], pch = 16 + as.numeric(str_sub(recs, 3, 3)), 
                   col = alpha(inds, time_saver/20))
  
  # Clean data
  clean_dat = data.frame(acc_dist = as.vector(dist(dat)))
  ## getting dimensions
  l = nrow(dat)
  c = combn(1:l, 2)
  ## call
  clean_dat$call_i = c[1,]
  clean_dat$call_j = c[2,]
  ## time
  clean_dat$month_diff = abs(day_saver[c[1,]] - day_saver[c[2,]])/30
  ## rec pair
  clean_dat$rec_pair = sapply(1:ncol(c), function(x) 
    paste(sort(c(recs[c[1,x]], recs[c[2,x]])), collapse = ' ')) |> as.factor() |> as.integer()
  ## ind
  clean_dat$ind = inds[c[1,]] %>% as.factor %>% as.integer
  ## remove across ind and remove within rec
  clean_dat = clean_dat[inds[c[1,]] == inds[c[2,]] &
                          recs[c[1,]] != recs[c[2,]],]
  ## redo integers calls
  call_trans = 1:length(unique(c(clean_dat$call_i, clean_dat$call_j)))
  names(call_trans) = as.character(unique(c(clean_dat$call_i, clean_dat$call_j)))
  clean_dat$call_i = call_trans[as.character(clean_dat$call_i)]
  clean_dat$call_j = call_trans[as.character(clean_dat$call_j)]
  ## scale
  clean_dat$acc_dist = as.vector(scale(clean_dat$acc_dist))
  ## sample sizes
  clean_dat = as.list(clean_dat)
  clean_dat$N_call = max(clean_dat$call_j)
  clean_dat$N_ind = max(clean_dat$ind)
  clean_dat$N_rec_pair = max(clean_dat$rec_pair)
  clean_dat$N_obs = length(clean_dat$call_i)
  
  # Return
  return(clean_dat)
  
}