// Project: chapter II
// Date started: 25-08-2021
// Date last modified: 26-08-2021
// Author: Simeon Q. Smeele
// Description: Multi-level model with based on social networks model. Includes varying effects for:
// call, individual and individual pair. 
// This version has an added parameter for whether or ind pair is the same ind. 
// This version adds the rec level. 
// This version actually has priors for all parameters and tighter priors for some others. 
data{
    int N_obs;
    int N_call;
    int N_rec;
    int N_ind;
    int N_ind_pair;
    int N_rec_pair;
    real d[N_obs];
    int call_i[N_obs];
    int call_j[N_obs];
    int rec_i[N_obs];
    int rec_j[N_obs];
    int ind_i[N_obs];
    int ind_j[N_obs];
    int ind_pair[N_obs];
    int rec_pair[N_obs];
    int same_ind[N_ind_pair];
}
parameters{
    real a;
    real a_ind_pair;
    real b_ind_pair;
    vector[N_ind] z_ind;
    vector[N_rec] z_rec;
    vector[N_call] z_call;
    vector[N_rec_pair] z_rec_pair;
    real<lower=0> sigma_ind_pair;
    real<lower=0> sigma_rec_pair;
    real<lower=0> sigma_ind;
    real<lower=0> sigma_rec;
    real<lower=0> sigma_call;
    real<lower=0> sigma;
}
model{
    vector[N_obs] mu;
    vector[N_ind_pair] z_ind_pair;
    sigma_ind_pair ~ exponential( 1 );
    sigma_rec_pair ~ exponential( 1 );
    sigma_ind ~ exponential( 1 );
    sigma_rec ~ exponential( 1 );
    sigma_call ~ exponential( 2 );
    sigma ~ exponential( 1 );
    b_ind_pair ~ normal( 0 , 0.5 );
    a_ind_pair ~ normal( 0 , 0.5 );
    // sub model that explains the offset for ind pair based on wheter or not it's the same ind
    for( n in 1:N_ind_pair ) {
      z_ind_pair[n] = a_ind_pair + b_ind_pair * same_ind[n];
    }
    z_ind ~ normal( 0 , 0.5 );
    z_call ~ normal( 0 , 0.5 );
    z_rec ~ normal( 0 , 0.5 );
    z_rec_pair ~ normal( 0 , 0.5 );
    a ~ normal( 0 , 0.5 );
    // main model
    for( n in 1:N_obs ) {
        mu[n] = 
        // global intercept
        a + 
        // offset for both calls
        z_call[call_i[n]] * sigma_call + z_call[call_j[n]] * sigma_call + 
        // offset for both recordings
        z_rec[rec_i[n]] * sigma_rec + z_rec[rec_j[n]] * sigma_rec  +
        // offset for the recording pair
        z_rec_pair[rec_pair[n]] * sigma_rec_pair +
        // offset for both individuals
        z_ind[ind_i[n]] * sigma_ind + z_ind[ind_j[n]] * sigma_ind +
        // offset for ind pair - this is determined in sub model
        z_ind_pair[ind_pair[n]] * sigma_ind_pair;
    }
    d ~ normal(mu, sigma);
}
