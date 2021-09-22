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
// This version adds back in the rec level. 
data{
    int N_obs; // number of rows (one row per call pair)
    int N_call; // number of calls
    int N_rec; // number of recordings (multiple calls per recording)
    int N_ind; // number of individuals (multiple calls per individual)
    int N_ind_pair; // number of pairs of individuals (either from same or two different)
    int N_rec_pair; // same for recording
    real d[N_obs]; // the accoustical distance between two calls (i and j)
    int call_i[N_obs]; // index for call i
    int call_j[N_obs]; 
    int rec_i[N_obs]; // index for the recording call i came from
    int rec_j[N_obs];
    int ind_i[N_obs]; // same for ind
    int ind_j[N_obs];
    int ind_pair[N_obs]; // this is not currently used
    int rec_pair[N_obs];
    int same_ind[N_ind_pair]; // whether or not indpair is the same of different ind
    int same_rec[N_rec_pair];
}
parameters{
    real a;
    real b_ind_pair[N_ind_pair];
    real b_bar;
    vector[N_ind] z_ind;
    vector[N_call] z_call;
    vector[N_rec] z_rec;
    vector[N_rec_pair] z_rec_pair;
    real<lower=0> sigma_rec_pair;
    real<lower=0> sigma_rec;
    real<lower=0> sigma_ind;
    real<lower=0> sigma_call;
    real<lower=0> sigma;
    real<lower=0> sigma_b;
}
model{
    vector[N_obs] mu;
    sigma_rec_pair ~ exponential( 1 );
    sigma_rec ~ exponential( 1 );
    z_rec ~ normal( 0 , 0.5 );
    z_rec_pair ~ normal( 0 , 0.5 );
    sigma_ind ~ exponential( 1 );
    sigma_call ~ exponential( 2 );
    sigma ~ exponential( 1 );
    sigma_b ~ exponential(1);
    b_bar ~ normal(0, 1);
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
        // offset for both recordings
        (z_rec[rec_i[n]] * sigma_rec + z_rec[rec_j[n]] * sigma_rec) * (1 - same_rec[rec_pair[n]]) +
        // offset for the recording pair
        z_rec_pair[rec_pair[n]] * sigma_rec_pair +
        // offset for both individuals
        (z_ind[ind_i[n]] * sigma_ind + z_ind[ind_j[n]] * sigma_ind) * (1 - same_ind[ind_pair[n]]) +
        // slope for whether or not it's the same ind
        -(b_bar + b_ind_pair[ind_pair[n]] * sigma_b) * same_ind[ind_pair[n]];
    }
    d ~ normal(mu, sigma);
}
