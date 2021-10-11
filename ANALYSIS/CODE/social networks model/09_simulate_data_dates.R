# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: chapter II
# Date started: 27-08-2021
# Date last modified: 08-10-2021
# Author: Simeon Q. Smeele
# Description: Simple simulation of data that we might get from dtw including dates 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('data.table', 'tidyverse', 'rethinking')
for(i in libraries){
  if(! i %in% installed.packages()) lapply(i, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Settings
set.seed(1)
settings = list(N_ind = 5,
                N_var = 2,
                lambda_obs = 4,
                lambda_rec = 5,
                sigma_ind = 1,
                sigma_rec = 0.2,
                sigma_obs = 0.1,
                slope_time = 0.00,
                slope_day = 0.05,
                dur_rec = 20,
                dur_dates = 20)

# Paths
path_functions = 'ANALYSIS/CODE/functions'
path_out = 'ANALYSIS/RESULTS/social networks model/sim_dat_date.RData'

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Simulate
clean_dat = sim.sn.data.time(settings, plot_it = T)
clean_dat$date = clean_dat$date/30

# Subset data
subber = which(clean_dat$same_ind[clean_dat$ind_pair] == 1)
if(any(clean_dat$ind_i[subber] != clean_dat$ind_j[subber])) stop('Problem subsetting!')
sub_dat = list(call_i = clean_dat$call_i[subber] %>% as.factor %>% as.integer,
               call_j = clean_dat$call_j[subber] %>% as.factor %>% as.integer,
               rec_pair = clean_dat$rec_pair[subber] %>% as.character %>% as.factor %>% as.integer,
               ind = clean_dat$ind_i[subber] %>% as.factor %>% as.integer,
               date = clean_dat$date[subber],
               d = clean_dat$d[subber] %>% scale %>% as.numeric,
               N_obs = length(subber),
               N_call = length(unique(c(clean_dat$call_i[subber],
                                        clean_dat$call_j[subber]))),
               N_rec_pair = max(clean_dat$rec_pair[subber] %>% as.character %>% as.factor %>% as.integer),
               N_ind = length(unique(clean_dat$ind_i[subber])),
               settings = clean_dat$settings)
sub_dat$date_per_rec = sapply(seq_along(unique(sub_dat$rec_pair)), 
                              function(x) sub_dat$date[sub_dat$rec_pair == x][1])
sub_dat$ind_per_rec = sapply(seq_along(unique(sub_dat$rec_pair)), 
                              function(x) sub_dat$ind[sub_dat$rec_pair == x][1])
plot(sub_dat$date, sub_dat$d, col = sub_dat$ind)

# Save
save(sub_dat, file = path_out)

# Print str
str(sub_dat)

# Report
message(sprintf('Simulated %s calls. Saved a total of %s data points',
                sub_dat$N_call, sub_dat$N_obs))