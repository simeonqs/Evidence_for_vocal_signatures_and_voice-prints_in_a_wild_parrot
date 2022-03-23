# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 17-03-2022
# Date last modified: 17-03-2022
# Author: Simeon Q. Smeele
# Description: Plotting the results of the real data. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('cmdstanr')
for(lib in libraries){
  if(! lib %in% installed.packages()) lapply(lib, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Paths
path_model_results_real = 'ANALYSIS/RESULTS/vectorised srm/post_real.RData'

# Load simulated data
load(path_model_results_real)

# Plot same ind
par(mfrow = c(2, 2))
plot(clean_dat$same_ind, clean_dat$acc_dist, main = 'same ind')
for(i in sample(1:length(post$a_bar), 10)) 
  points(1, post$a_bar[i] + post$z_same_ind[i, 1] * post$sigma_same_ind[i],
         col = 'red')
for(i in sample(1:length(post$a_bar), 10)) 
  points(2, post$a_bar[i] + post$z_same_ind[i, 2] * post$sigma_same_ind[i],
         col = 'red')
points(1, mean(sapply(1:length(post$a_bar), function(i) 
  post$a_bar[i] + post$z_same_ind[i, 1] * post$sigma_same_ind[i])),
  col = 'red', pch = 16)
points(2, mean(sapply(1:length(post$a_bar), function(i) 
  post$a_bar[i] + post$z_same_ind[i, 2] * post$sigma_same_ind[i])),
  col = 'red', pch = 16)

# Plot same rec
plot(clean_dat$same_rec, clean_dat$acc_dist, main = 'same rec')
for(i in sample(1:length(post$a_bar), 10)) 
  points(1, post$a_bar[i] + post$z_same_rec[i, 1] * post$sigma_same_rec[i],
         col = 'red')
for(i in sample(1:length(post$a_bar), 10)) 
  points(2, post$a_bar[i] + post$z_same_rec[i, 2] * post$sigma_same_rec[i],
         col = 'red')
points(1, mean(sapply(1:length(post$a_bar), function(i) 
  post$a_bar[i] + post$z_same_rec[i, 1] * post$sigma_same_rec[i])),
  col = 'red', pch = 16)
points(2, mean(sapply(1:length(post$a_bar), function(i) 
  post$a_bar[i] + post$z_same_rec[i, 2] * post$sigma_same_rec[i])),
  col = 'red', pch = 16)

# # Plot ind pairs
# plot(clean_dat$ind_pair, clean_dat$acc_dist)
# for(i in sample(1:length(post$a_bar), 10)) 
#   for(j in 1:ncol(post$z_ind_pair))
#     points(j, post$a_bar[i] + post$z_ind_pair[i, j] * post$sigma_ind_pair[i] + 
#              post$z_same_ind[i, clean_dat$same_ind[clean_dat$ind_pair == j][1]] * post$sigma_same_ind[i],
#            col = 'red')

# # Plot rec pairs
# plot(clean_dat$rec_pair, clean_dat$acc_dist)
# for(i in sample(1:length(post$a_bar), 10)) 
#   for(j in 1:ncol(post$z_rec_pair))
#     points(j, post$a_bar[i] + post$z_rec_pair[i, j] * post$sigma_rec_pair[i] + 
#              post$z_same_rec[i, clean_dat$same_rec[clean_dat$rec_pair == j][1]] * post$sigma_same_rec[i],
#            col = 'red')

# Plot precis
post$lp__ = NULL
plot(precis(post, depth = 1))

# Plot difference
par(mfrow = c(1, 1))
diff_ind = sapply(1:length(post$a_bar), function(i) 
  (post$z_same_ind[i, 2] - post$z_same_ind[i, 1]) * post$sigma_same_ind[i])
dens(diff_ind)
diff_rec = sapply(1:length(post$a_bar), function(i) 
  (post$z_same_rec[i, 2] - post$z_same_rec[i, 1]) * post$sigma_same_ind[i])
dens(diff_rec, col = 2, add = T)
abline(v = 0, lty = 2, col = 'grey')


