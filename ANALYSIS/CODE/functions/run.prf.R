# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 10-05-2022
# Date last modified: 12-05-2022
# Author: Simeon Q. Smeele
# Description: This function runs the permuted random forest
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

require(randomForest)

run.prf = function(train_set, test_set,
                   n_iter = 100, 
                   N_train = 15, N_test = 10, 
                   mfcc_out, st, 
                   permute = F,
                   main = ''){
  
  prf_out = lapply(1:n_iter, function(i){
    out = subset.dfa(N_train = N_train, N_test = N_test, 
                     train_set = train_set, test_set = test_set,
                     st = st,
                     balance = T)
    rf_out = run.rf(names_train = out$names_train, 
                    names_test = out$names_test, 
                    mfcc_out = mfcc_out,
                    permute = permute)
    rf_out['N'] = out$N
    return(rf_out)
  }) %>% bind_rows
  
  if(min(prf_out$N) != max(prf_out$N)) warning('Samp sizes do not match.')
  
  plot(density(prf_out$score_diff), lwd = 3, col = 4, main = main, ylim = c(0, 12),
       xlab = 'difference proportion correct classified', ylab = 'density', xlim = c(-0.2, 0.5))
  abline(v = 0, lty = 2, lwd = 3, col = alpha('black', 0.3))
  text(0.43, 
       11, 
       sprintf('N = %s', round(mean(prf_out$N[1]), 2)))
  return(prf_out)
}