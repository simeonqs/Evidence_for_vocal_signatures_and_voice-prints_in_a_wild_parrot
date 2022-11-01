// Project: voice paper
// Date started: 21-03-2022
// Date last modified: 30-04-2022
// Author: Simeon Q. Smeele
// Description: Multi-level model for time within recording effect. 
// This version has priors for normalised instead of standardised acoustic distance. 
data{
    int N_obs; // number of rows (one row per call pair)
    int N_call; // number of calls
    int N_ind; // number of individuals (multiple calls per individual)
    int N_rec; // number of recordings (multiple calls per recording)
    real acc_dist[N_obs]; // the accoustical distance between two calls (i and j)
    int call_i[N_obs]; // index for call i
    int call_j[N_obs]; 
    int ind[N_obs];
    int rec[N_obs]; 
    real time_diff_log[N_obs]; // time in log(minutes)
}
parameters{
    real a_bar;
    real b_bar;
    real<lower=0> sigma;
    real<lower=0> sigma_call;
    real<lower=0> sigma_ind;
    real<lower=0> sigma_rec;
    real<lower=0> sigma_ind_b;
    real<lower=0> sigma_rec_b;
    vector[N_rec] b_rec;
    vector[N_ind] b_ind;
    vector[N_call] z_call;
    vector[N_rec] z_rec;
    vector[N_ind] z_ind;
}
model{
    vector[N_obs] mu;
    sigma_call ~ exponential(3);
    sigma ~ exponential(3);
    sigma_rec ~ exponential(3);
    sigma_ind ~ exponential(3);
    sigma_rec_b ~ exponential(3);
    sigma_ind_b ~ exponential(3);
    b_ind ~ normal(0, 1);
    b_rec ~ normal(0, 1);
    b_bar ~ normal(0, 0.1);
    z_call ~ normal(0, 1);
    z_rec ~ normal(0, 1);
    z_ind ~ normal(0, 1);
    a_bar ~ normal(0.5, 0.25);
    for( n in 1:N_obs ) {
        mu[n] =
        // global intercept
        a_bar +
        // offset for both calls
        (z_call[call_i[n]] + z_call[call_j[n]]) * sigma_call +
        // offset for rec and ind
        z_ind[ind[n]] * sigma_ind + z_rec[rec[n]] * sigma_rec + 
        // slope for time difference
        (b_bar + b_ind[ind[n]] * sigma_ind_b + b_rec[rec[n]] * sigma_rec_b) * time_diff_log[n];
    }
    acc_dist ~ normal(mu, sigma);
}
