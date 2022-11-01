# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 21-02-2022
# Date last modified: 09-05-2022
# Author: Simeon Q. Smeele
# Description: This function runs the permuted DFA. For each iteration it creates a training and testing
# set based on the settings. It then runs a single DFA for the labelled and randomised data. Due to limited
# number of attempts to find a usable train/test split not all individuals will always be included. The 
# function returns the trained score, random score, pair-wise difference and plots the density of the 
# contrast.
# This version has to option to randomise within nesting locations. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

run.pdfa = function(train_set, test_set,
                    n_iter = 100, 
                    N_train = 15, N_test = 10, 
                    mfcc_out, st, 
                    permute = F,
                    main = ''){
  
  pdfa_out = lapply(1:n_iter, function(i){
    out = subset.dfa(N_train = N_train, N_test = N_test, 
                     train_set = train_set, test_set = test_set,
                     st = st,
                     balance = T)
    dfa_out = run.dfa(names_train = out$names_train, 
                      names_test = out$names_test, 
                      mfcc_out = mfcc_out,
                      permute = permute)
    dfa_out['N'] = out$N
    return(dfa_out)
  }) %>% bind_rows
  
  if(min(pdfa_out$N) != max(pdfa_out$N)) warning('Samp sizes do not match.')
  
  # plot(density(pdfa_out$score_random), lwd = 3, col = 4, main = main, 
  #      xlab = 'proportion correct classified', ylab = 'density', xlim = c(0, 0.5))
  # text(0.43, 
  #      max(density(pdfa_out$score_random)$y) - max(density(pdfa_out$score_random)$y)/10, 
  #      sprintf('N = %s', round(mean(pdfa_out$N[1]), 2)))
  # lines(density(pdfa_out$score), lwd = 3, col = 3)
  plot(density(pdfa_out$score_diff), lwd = 3, col = 4, main = main, ylim = c(0, 12),
       xlab = 'difference proportion correct classified', ylab = 'density', xlim = c(-0.2, 0.5))
  abline(v = 0, lty = 2, lwd = 3, col = alpha('black', 0.3))
  text(0.43, 
       11, 
       sprintf('N = %s', round(mean(pdfa_out$N[1]), 2)))
  return(pdfa_out)
}