// Project: voice paper
// Date started: 15-03-2022
// Date last modified: 15-03-2022
// Author: Simeon Q. Smeele
// Description: Vectorised multilevel model based on social relations model. 
data{
    int N_obs; 
    int N_ind_pair;
    vector[N_obs] acc_dist;
    int same_ind[N_obs];
}
parameters{
    real<lower=0> sigma;
    real<lower=0> sigma_ind;
    vector[2] a;
    real a_bar;
}
model{
    sigma ~ exponential(1);
    sigma_ind ~ exponential(1);
    a_bar ~ normal(0, 1);
    a ~ normal(a_bar, sigma_ind);
    acc_dist ~ normal(a[same_ind], sigma);
}
