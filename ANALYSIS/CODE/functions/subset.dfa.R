# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 15-02-2022
# Date last modified: 21-02-2022
# Author: Simeon Q. Smeele
# Description: Subsets recordings per individual for DFA.  
# This version includes options for test and train set. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

subset.dfa = function(N_train, N_test, train_set, test_set){
  
  # Subset recordings
  inds = unique(st$bird)
  inds_include = c()
  recs_train = c()
  recs_test = c()
  
  ## Run through ids
  for(ind in inds){
    st_sub = st[st$bird == ind,] # subset for id
    recs = unique(st_sub$file) # get all recordings for that id
    if(length(recs) < 2) next # if not at least two, skip
    
    # Try to subset into train and test
    cont = T
    rec_train = c()
    rec_test = c()
    n_test = 0
    ii = 0
    while(cont){
      ii = ii + 1
      # Test if enough testing calls
      if(n_test < N_test){
        # If not add one recording to the testing set
        rec_test = c(rec_test, sample(recs[!recs %in% rec_test], 1))
      } else {
        # If yes
        rec_train = recs[!recs %in% rec_train]
      }
      # Test if enough
      n_test = length(which(st_sub$file %in% rec_test & st_sub$main_type %in% test_set))
      n_train = length(which(st_sub$file %in% rec_train & st_sub$main_type %in% train_set))
      # Test if continue
      if(length(rec_test) == length(recs)) cont = F # stop if not enough recordings at all
      if(length(rec_train) > 0 & n_train < N_train) { # reset if not enough left
        rec_test = rec_train = c()
        n_test = 0
      } 
      if(ii > 1000) cont = F # stop if not able to resolve
      if(n_test >= N_test & n_train >= N_train){cont = F; inds_include = c(inds_include, ind)}
    }
    
    # If successfull save the train and test recording names
    if(ind %in% inds_include){
      recs_train = c(recs_train, rec_train)
      recs_test = c(recs_test, rec_test)
    }
    
  } # end ind loop
  
  if(any(recs_train %in% recs_test) | any(recs_test %in% recs_train)) 
    stop('Some recordings go across sets!')
  
  return(list(recs_train = recs_train, 
              recs_test = recs_test, 
              inds_include = inds_include))
  
}