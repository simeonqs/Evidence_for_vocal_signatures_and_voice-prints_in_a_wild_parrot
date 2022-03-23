# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: sna model
# Date started: 29-08-2021
# Date last modified: 21-03-2022
# Author: Simeon Q. Smeele
# Description: This function runs the simulation for the data that can be analysed with a social networks
# model. 
# This version redoes most of the code to check if previous code as correct. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

require(tidyverse)

sim.vrsm.data = function(settings = list(N_ind = 3,
                                           N_var = 5,
                                           lambda_rec = 2,
                                           lambda_obs = 2,
                                           sigma_ind = 1,
                                           sigma_rec = 0.001,
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
  if(plot_it){
    pch_recs = recs
    for(ind in inds) pch_recs[inds == ind] = as.integer(as.factor(recs[inds == ind]))
    plot(dat[,1], dat[,2], col = inds, pch = 15 + pch_recs)
  } 
  
  # Make vectors
  names(dat) = paste0('x', 1:ncol(dat))
  ## acoustic distance
  clean_dat = list(acc_dist = as.vector(scale(as.vector(dist(dat)))))
  ## getting dimensions
  l = nrow(dat)
  c = combn(1:l, 2)
  ## call
  clean_dat$call_i = c[1,]
  clean_dat$call_j = c[2,]
  ## ind
  clean_dat$ind_i = inds[c[1,]]
  clean_dat$ind_j = inds[c[2,]]
  ## rec
  clean_dat$rec_i = recs[c[1,]]
  clean_dat$rec_j = recs[c[2,]]
  ## same ind = 1, else = 0
  clean_dat$same_ind = sapply(1:ncol(c), function(x) ifelse(inds[c[1,x]] == inds[c[2,x]], 1, 2))
  ## same rec = 1, else = 0
  clean_dat$same_rec = sapply(1:ncol(c), function(x) ifelse(recs[c[1,x]] == recs[c[2,x]], 1, 2))
  ## ind pair
  clean_dat$ind_pair = sapply(1:ncol(c), function(x) 
    paste(sort(c(inds[c[1,x]], inds[c[2,x]])), collapse = ' ')) |> as.factor() |> as.integer()
  ## rec pair
  clean_dat$rec_pair = sapply(1:ncol(c), function(x) 
    paste(sort(c(recs[c[1,x]], recs[c[2,x]])), collapse = ' ')) |> as.factor() |> as.integer()
  clean_dat$N_ind_pair = max(clean_dat$ind_pair)
  clean_dat$N_rec_pair = max(clean_dat$rec_pair)
  clean_dat$N_call = max(clean_dat$call_j)
  clean_dat$N_ind = max(clean_dat$ind_j)
  clean_dat$N_rec = max(clean_dat$rec_j)
  clean_dat$N_obs = length(clean_dat$call_i)
  
  # Return
  return(clean_dat)
  
}