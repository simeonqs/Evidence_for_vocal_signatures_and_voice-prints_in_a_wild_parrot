# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 17-03-2022
# Date last modified: 17-03-2022
# Author: Simeon Q. Smeele
# Description: Preparing the real data to test the vectorised srm.
# source('ANALYSIS/CODE/vectorised srm/03_run_real_data.R')
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('tidyverse', 'cmdstanr')
for(lib in libraries){
  if(! lib %in% installed.packages()) lapply(lib, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Clean R
rm(list=ls()) 

# Paths
source('ANALYSIS/CODE/paths.R')
path_model = 'ANALYSIS/CODE/vectorised srm/m_5.stan'
path_model_results_real = 'ANALYSIS/RESULTS/vectorised srm/post_real.RData'

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Load data
load(path_data)
load(path_dtw_m_list)

# Prep data
n = rownames(m_list$contact)
subber = 1:length(n)
if(length(n) > 100) subber = sample(length(n), 100) else subber = 1:length(n)
inds = st[n,]$bird[subber] %>% as.factor %>% as.integer
recs = paste(st[n,]$bird[subber], st[n,]$file[subber]) %>% as.factor %>% as.integer
m =  m_list$contact[subber, subber]

# Make vectors
## acoustic distance
clean_dat = list(acc_dist = as.vector(scale(as.vector(as.dist(m)))))
## getting dimensions
l = nrow(m)
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

# Run model and save
model = cmdstan_model(path_model)
fit = model$sample(data = clean_dat, 
                   seed = 1, 
                   chains = 4, 
                   parallel_chains = 4,
                   refresh = 2000, 
                   adapt_delta = 0.99,
                   max_treedepth = 15)
print(fit$summary())
fit$output_files() |>
  rstan::read_stan_csv() |>
  rethinking::extract.samples() -> post
save(post, clean_dat, file = path_model_results_real)