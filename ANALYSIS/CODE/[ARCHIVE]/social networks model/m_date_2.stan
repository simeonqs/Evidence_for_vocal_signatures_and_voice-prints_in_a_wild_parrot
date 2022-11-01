// Project: chapter II
// Date started: 02-10-2021
// Date last modified: 29-01-2022
// Author: Simeon Q. Smeele
// Description: Multi-level model for date between recording effect. 
data{
    int N_obs; // number of rows (one row per call pair)
    int N_call; // number of calls
    int N_ind; // number of individuals (multiple calls per individual)
    int N_rec_pair; // number of recordings (multiple calls per recording)
    real d[N_obs]; // the accoustical distance between two calls (i and j)
    int call_i[N_obs]; // index for call i
    int call_j[N_obs]; 
    int rec_pair[N_obs]; 
    int ind_per_rec[N_rec_pair];
    real date_per_rec[N_rec_pair]; // time in months between recordings
}
parameters{
    real a_bar;
    vector[N_ind] z_ind;
    real b_bar;
    vector[N_ind] b_ind;
    real<lower=0> sigma;
    real<lower=0> sigma_call;
    real<lower=0> sigma_z_ind;
    real<lower=0> sigma_b_ind;
    vector[N_call] z_call;
}
model{
    vector[N_obs] mu;
    vector[N_rec_pair] a_rec;
    a_bar ~ normal(0, 1);
    z_ind ~ normal(0, 1);
    sigma_call ~ exponential(2);
    sigma_z_ind ~ exponential(1);
    sigma_b_ind ~ exponential(1);
    sigma ~ exponential(1);
    b_bar ~ normal(0, 0.05);
    b_ind ~ normal(0, 1);
    z_call ~ normal(0, 1);
    // explaining the recording means with distance in months between
    for( n in 1:N_rec_pair ) {
        a_rec[n] = a_bar + z_ind[ind_per_rec[n]] * sigma_z_ind +
        (b_bar + b_ind[ind_per_rec[n]] * sigma_b_ind) * date_per_rec[n];
    }
    // main model
    for( n in 1:N_obs ) {
        mu[n] =
        // intercept per rec pair
        a_rec[rec_pair[n]] +
        // offset for both calls
        (z_call[call_i[n]] + z_call[call_j[n]]) * sigma_call;
    }
    d ~ normal(mu, sigma);
}
