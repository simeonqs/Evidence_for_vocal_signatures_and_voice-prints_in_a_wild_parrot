# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: social networks
# Date started: 27-08-2021
# Date last modified: 20-10-2021
# Author: Simeon Q. Smeele
# Description: Running the SN model. 
# This version runs the sn model with same/different rec level. 
# This version has the option to include time between recordings. 
# This version has the option to include time within recordings. 
# This version now takes the dataset and dist matrix object directly. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

run.sn.model = function(data_set,
                        m_dist, 
                        path_model,
                        N_obs = NULL, 
                        incl_time_between = F,
                        incl_time_within = F){
  
  # Optional subset
  if(!is.null(N_obs) & N_obs < nrow(m_dist)){
    s = sample(1:nrow(data_set), N_obs)
    m_dist = m_dist[s, s]
    data_set = data_set[s,]
  }
  
  # Report start
  message('\n==============================================================================\n')
  message(sprintf('Cleaning data with %s calls.\n', 
                  nrow(data_set)))
  
  # List data
  if(incl_time_within) time_saver = data_set$time else time_saver = NULL
  d = m.to.df(m_dist, 
              inds = as.integer(as.factor(data_set$bird)), 
              recs = as.integer(as.factor(data_set$file)))
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
  if(incl_time_within) clean_dat$time = clean_dat$time/3600
  
  # Report
  message('Starting model with ', clean_dat$N_obs, ' observations.\n')
  
  # Run model
  model = stan(path_model,
               data = clean_dat, 
               chains = 4, cores = 4,
               iter = 2000, warmup = 500,
               control = list(max_treedepth = 15, adapt_delta = 0.95))
  
  # Return
  return(list(model = model, clean_dat = clean_dat))
  
  # Print the results
  message('Here are the results:')
  print(precis(model, depth = 1))
  
} # end function