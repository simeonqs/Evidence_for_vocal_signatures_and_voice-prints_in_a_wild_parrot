// Project: chapter II
// Date started: 25-08-2021
// Date last modified: 25-08-2021
// Author: Simeon Q. Smeele
// Description: Multi-level model with based on social networks model. Includes varying effects for:
// call, individual and individual pair. 
// This version has an added parameter for whether or ind pair is the same ind. 
data{
    int N_obs;
    int N_call;
    int N_ind;
    int N_ind_pair;
    real d[N_obs];
    int call_i[N_obs];
    int call_j[N_obs];
    int ind_i[N_obs];
    int ind_j[N_obs];
    int ind_pair[N_obs];
    int same_ind[N_ind_pair];
}
parameters{
    real a;
    real a_ind_pair;
    real b_ind_pair;
    vector[N_ind] z_ind;
    vector[N_call] z_call;
    real<lower=0> sigma_ind_pair;
    real<lower=0> sigma_ind;
    real<lower=0> sigma_call;
    real<lower=0> sigma;
}
model{
    vector[N_obs] mu;
    vector[N_ind_pair] z_ind_pair;
    sigma_ind_pair ~ exponential( 1 );
    sigma_ind ~ exponential( 1 );
    sigma_call ~ exponential( 1 );
    sigma ~ exponential( 1 );
    b_ind_pair ~ normal( 0 , 1 );
    a_ind_pair ~ normal( 0 , 1 );
    for( n in 1:N_ind_pair ) {
      z_ind_pair[n] = a_ind_pair + b_ind_pair * same_ind[n];
    }
    z_ind ~ normal( 0 , 1 );
    z_call ~ normal( 0 , 1 );
    a ~ normal( 0 , 1 );
    for( n in 1:N_obs ) {
        mu[n] = a + 
        z_call[call_i[n]] * sigma_call + z_call[call_j[n]] * sigma_call + 
        z_ind[ind_i[n]] * sigma_ind + z_ind[ind_j[n]] * sigma_ind +
        z_ind_pair[ind_pair[n]] * sigma_ind_pair;
    }
    d ~ normal(mu, sigma);
}
