# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: social networks
# Date started: 27-08-2021
# Date last modified: 06-09-2021
# Author: Simeon Q. Smeele
# Description: Running the SN model. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

run.sn.model = function(path_data_set,
                        path_model,
                        path_out,
                        N_obs = NULL){
  
  # Load data
  load(path_data_set)
  
  # Optional subset
  if(!is.null(N_obs) & N_obs < nrow(m_sub)){
    s = sample(1:nrow(d_sub), N_obs)
    m_sub = m_sub[s, s]
    d_sub = d_sub[s,]
  }
  
  # Report start
  split = path_data_set %>% strsplit('/')
  name_data = split[[1]][length(split[[1]])] %>% str_remove('.RData')
  message('\n==============================================================================\n')
  message(sprintf('Cleaning data for *%s* with %s calls.\n', 
                  name_data, nrow(d_sub)))
  
  # List data
  d = m.to.df(m_sub, 
              inds = as.integer(as.factor(d_sub$ind)), 
              recs = as.integer(as.factor(d_sub$file)))
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
  
  # Report
  message('Starting model with ', clean_dat$N_obs, ' observations.\n')
  
  # Run model
  model = stan(path_model,
               data = clean_dat, 
               chains = 4, cores = 4,
               iter = 2000, warmup = 500,
               control = list(max_treedepth = 15, adapt_delta = 0.95))
  
  # Save
  save('model', file = paste0(path_out, '/', name_data, '.RData'))
  
  # Print the results
  message('Here are the results:\n')
  print(precis(model, depth = 1))
  
} # end function