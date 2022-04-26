// Project: chapter II
// Date started: 30-01-2022
// Date last modified: 31-03-2022
// Author: Simeon Q. Smeele
// Description: Multi-level model for year effect. 
// This version is simplified.
data{
    int N_obs; 
    int N_call; 
    int N_ind;
    int N_rec_pair; 
    real acc_dist[N_obs]; 
    int call_i[N_obs]; 
    int call_j[N_obs]; 
    int rec_pair[N_obs]; 
    int ind[N_obs];
    int same_year[N_obs]; 
}
parameters{
    real a_bar;
    vector[2] z_year;
    vector[N_ind] z_ind;
    vector[N_rec_pair] z_rec_pair;
    vector[N_call] z_call;
    real<lower=0> sigma;
    real<lower=0> sigma_call;
    real<lower=0> sigma_ind;
    real<lower=0> sigma_year;
    real<lower=0> sigma_rec_pair;
}
model{
    a_bar ~ normal(0, 0.5);
    z_year ~ normal(0, 1);
    z_ind ~ normal(0, 1);
    z_rec_pair ~ normal(0, 1);
    z_call ~ normal(0, 1);
    sigma ~ exponential(2);
    sigma_call ~ exponential(2);
    sigma_ind ~ exponential(2);
    sigma_year ~ exponential(2);
    sigma_rec_pair ~ exponential(2);
    acc_dist ~ normal(a_bar + 
        z_year[same_year] * sigma_year +
        z_ind[ind] * sigma_ind + 
        z_rec_pair[rec_pair] * sigma_rec_pair + 
        (z_call[call_i] + z_call[call_j]) * sigma_call, 
                     sigma);
}
