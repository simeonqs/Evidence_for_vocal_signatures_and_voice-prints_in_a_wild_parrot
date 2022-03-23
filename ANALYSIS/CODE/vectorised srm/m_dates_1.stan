// Project: voice paper
// Date started: 21-03-2022
// Date last modified: 21-03-2022
// Author: Simeon Q. Smeele
// Description: Multi-level model for date between recording effect. 
data{
    int N_obs; // number of rows (one row per call pair)
    int N_call; // number of calls
    int N_ind; // number of individuals (multiple calls per individual)
    int N_rec_pair; // number of recordings (multiple calls per recording)
    real acc_dist[N_obs]; // the accoustical distance between two calls (i and j)
    int call_i[N_obs]; // index for call i
    int call_j[N_obs]; 
    int rec_pair[N_obs]; 
    int ind[N_obs];
    real month_diff[N_obs]; // time in months between recordings
}
parameters{
    real a_bar;
    vector[N_ind] z_ind;
    vector[N_rec_pair] z_rec_pair;
    vector[N_call] z_call;
    real b_bar;
    vector[N_ind] b_ind;
    real<lower=0> sigma;
    real<lower=0> sigma_z_call;
    real<lower=0> sigma_z_ind;
    real<lower=0> sigma_z_rec_pair;
    real<lower=0> sigma_b_ind;
}
model{
    vector[N_obs] mu;
    a_bar ~ normal(0, 0.5);
    z_ind ~ normal(0, 1);
    z_rec_pair ~ normal(0, 1);
    z_call ~ normal(0, 1);
    b_bar ~ normal(0, 0.5);
    b_ind ~ normal(0, 1);
    sigma ~ exponential(1);
    sigma_z_call ~ exponential(2);
    sigma_z_ind ~ exponential(2);
    sigma_z_rec_pair ~ exponential(2);
    sigma_b_ind ~ exponential(2);
    for( n in 1:N_obs ) {
        mu[n] =
        // intercept
        a_bar + 
        z_ind[ind[n]] * sigma_z_ind + 
        z_rec_pair[rec_pair[n]] * sigma_z_rec_pair + 
        (z_call[call_i[n]] + z_call[call_j[n]]) * sigma_z_call + 
        // slope
        (b_bar + b_ind[ind[n]] * sigma_b_ind) * month_diff[n];
    }
    acc_dist ~ normal(mu, sigma);
}
