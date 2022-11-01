// Project: voice paper
// Date started: 15-03-2022
// Date last modified: 15-03-2022
// Author: Simeon Q. Smeele
// Description: Vectorised multilevel model based on social relations model. 
// This version adds more layers. 
// This version is un-centered.
data{
    int N_obs; 
    int N_ind_pair;
    real acc_dist[N_obs];
    int same_ind[N_obs];
    int ind_pair[N_obs];
}
parameters{
    real<lower=0> sigma;
    real<lower=0> sigma_same_ind;
    real<lower=0> sigma_ind_pair;
    real a_bar;
    vector[2] z_same_ind;
    vector[N_ind_pair] z_ind_pair;
}
model{
    sigma ~ exponential(1);
    sigma_same_ind ~ exponential(1);
    sigma_ind_pair ~ exponential(1);
    a_bar ~ normal(0, 1);
    z_same_ind ~ normal(0, 1);
    z_ind_pair ~ normal(0, 1);
    acc_dist ~ normal(a_bar + 
                        z_same_ind[same_ind] * sigma_same_ind + 
                        z_ind_pair[ind_pair] * sigma_ind_pair, 
                      sigma);
}
