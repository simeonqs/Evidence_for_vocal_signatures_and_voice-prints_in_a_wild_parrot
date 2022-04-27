// Project: voice paper
// Date started: 15-03-2022
// Date last modified: 17-03-2022
// Author: Simeon Q. Smeele
// Description: Vectorised multilevel model based on social relations model. 
// This version adds more layers. 
// This version is un-centered.
// This version adds more layers.
// This version adds the rec level. 
data{
    int N_obs; 
    int N_call;
    int N_rec_pair;
    int N_ind_pair;
    real acc_dist[N_obs];
    int call_i[N_obs];
    int call_j[N_obs];
    int rec_pair[N_obs];
    int same_rec[N_obs];
    int ind_pair[N_obs];
    int same_ind[N_obs];
}
parameters{
    real<lower=0> sigma;
    real<lower=0> sigma_same_ind;
    real<lower=0> sigma_ind_pair;
    real<lower=0> sigma_same_rec;
    real<lower=0> sigma_rec_pair;
    real<lower=0> sigma_call;
    real a_bar;
    vector[2] z_same_ind;
    vector[N_ind_pair] z_ind_pair;
    vector[2] z_same_rec;
    vector[N_rec_pair] z_rec_pair;
    vector[N_call] z_call;
}
model{
    sigma ~ exponential(5);
    sigma_same_ind ~ exponential(3);
    sigma_ind_pair ~ exponential(3);
    sigma_same_rec ~ exponential(3);
    sigma_rec_pair ~ exponential(3);
    sigma_call ~ exponential(5);
    a_bar ~ normal(0, 0.25);
    z_same_ind ~ normal(0, 1);
    z_ind_pair ~ normal(0, 1);
    z_same_rec ~ normal(0, 1);
    z_rec_pair ~ normal(0, 1);
    z_call ~ normal(0, 1);
    acc_dist ~ normal(a_bar + 
                        z_same_ind[same_ind] * sigma_same_ind + 
                        z_ind_pair[ind_pair] * sigma_ind_pair + 
                        z_same_rec[same_rec] * sigma_same_rec + 
                        z_rec_pair[rec_pair] * sigma_rec_pair + 
                        (z_call[call_i] + z_call[call_j]) * sigma_call, 
                      sigma);
}
