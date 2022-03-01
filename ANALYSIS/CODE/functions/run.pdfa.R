# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 21-02-2022
# Date last modified: 21-02-2022
# Author: Simeon Q. Smeele
# Description: Running and plotting all functions for DFA.
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

run.pdfa = function(train_set, test_set,
                    n_iter = 100, 
                    N_train = 15, N_test = 10, 
                    main = ''){
  
  pdfa_out = lapply(1:n_iter, function(i){
    out = subset.dfa(N_train = N_train, N_test = N_test, 
                     train_set = train_set, test_set = test_set,
                     balance = T)
    dfa_out = run.dfa(out$names_train, out$names_test)
    return(dfa_out)
  }) %>% bind_rows
  
  plot(density(pdfa_out$score_random), lwd = 3, col = 4, main = main, 
       xlab = 'proportion correct classified', ylab = 'density', xlim = c(0, 0.5))
  lines(density(pdfa_out$score), lwd = 3, col = 3)
  
}