// Project: chapter II
// Date started: 25-08-2021
// Date last modified: 30-08-2021
// Author: Simeon Q. Smeele
// Description: Multi-level model with based on social networks model. Includes varying effects for:
// call, individual and individual pair.
// This version has an added parameter for whether or ind pair is the same ind.
// This version adds the rec level.
// This version actually has priors for all parameters and tighter priors for some others.
// This version has fixed priors for the slope, as it cannot be negative.
// This version has no intercept for the ind pair as there is already a global intercept.
// This version has no rec level and the beta is moved into the main model as varying effect. 
// This version has an uncentered slope. 
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
    real b_ind_pair[N_ind_pair];
    real b_bar;
    vector[N_ind] z_ind;
    vector[N_call] z_call;
    real<lower=0> sigma_ind;
    real<lower=0> sigma_call;
    real<lower=0> sigma;
    real<lower=0> sigma_b;
}
model{
    vector[N_obs] mu;
    sigma_ind ~ exponential( 1 );
    sigma_call ~ exponential( 2 );
    sigma ~ exponential( 1 );
    sigma_b ~ exponential(1);
    b_bar ~ normal(0, 0.5);
    b_ind_pair ~ normal( 0, 1 );
    z_ind ~ normal( 0 , 0.5 );
    z_call ~ normal( 0 , 0.5 );
    a ~ normal( 0 , 0.5 );
    // main model
    for( n in 1:N_obs ) {
        mu[n] =
        // global intercept
        a +
        // offset for both calls
        z_call[call_i[n]] * sigma_call + z_call[call_j[n]] * sigma_call +
        // offset for both individuals
        z_ind[ind_i[n]] * sigma_ind + z_ind[ind_j[n]] * sigma_ind +
        // slope for whether or not it's the same ind
        -(b_bar + b_ind_pair[ind_pair[n]] * sigma_b) * same_ind[ind_pair[n]];
    }
    d ~ normal(mu, sigma);
}
