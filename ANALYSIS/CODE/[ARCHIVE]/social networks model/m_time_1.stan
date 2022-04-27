// Project: chapter II
// Date started: 30-09-2021
// Date last modified: 30-09-2021
// Author: Simeon Q. Smeele
// Description: Multi-level model for time within recording effect. 
data{
    int N_obs; // number of rows (one row per call pair)
    int N_call; // number of calls
    int N_ind; // number of individuals (multiple calls per individual)
    int N_rec; // number of recordings (multiple calls per recording)
    real d[N_obs]; // the accoustical distance between two calls (i and j)
    int call_i[N_obs]; // index for call i
    int call_j[N_obs]; 
    int ind[N_obs];
    int rec[N_obs]; 
    real time[N_obs]; // time in hours between two recordings
}
parameters{
    real a;
    vector[N_call] z_call;
    vector[N_rec] b_rec;
    vector[N_ind] b_ind;
    real b_bar;
    real<lower=0> sigma;
    real<lower=0> sigma_call;
    real<lower=0> sigma_ind;
    real<lower=0> sigma_rec;
}
model{
    vector[N_obs] mu;
    sigma_call ~ exponential(2);
    sigma ~ exponential(1);
    sigma_rec ~ exponential(1);
    sigma_ind ~ exponential(1);
    b_ind ~ normal(0, 1);
    b_rec ~ normal(0, 1);
    b_bar ~ normal(0, 1);
    z_call ~ normal(0, 1);
    a ~ normal(0, 0.5);
    // main model
    for( n in 1:N_obs ) {
        mu[n] =
        // global intercept
        a +
        // offset for both calls
        (z_call[call_i[n]] + z_call[call_j[n]]) * sigma_call +
        // slope for distance in hours within recordings, multiply by same rec to only consider same rec
        (b_bar + b_ind[ind[n]] * sigma_ind + b_rec[rec[n]] * sigma_rec) * time[n];
    }
    d ~ normal(mu, sigma);
}
