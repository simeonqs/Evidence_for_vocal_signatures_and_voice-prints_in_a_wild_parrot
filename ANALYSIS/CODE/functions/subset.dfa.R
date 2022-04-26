# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 15-02-2022
# Date last modified: 25-04-2022
# Author: Simeon Q. Smeele
# Description: Subsets recordings per individual for DFA.  
# This version includes options for test and train set. 
# This version includes the option the balance the data set. 
# This version includes more test code and the max_iter can be set. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

subset.dfa = function(N_train, N_test, 
                      train_set, test_set, 
                      st,
                      balance = T,
                      max_iter = 1000){
  
  # Subset recordings
  inds = unique(st$bird)
  inds_include = c()
  names_train = c()
  names_test = c()
  
  ## Run through ids
  for(ind in inds){
    st_sub = st[st$bird == ind,] # subset for id
    recs = unique(st_sub$file) # get all recordings for that id
    if(length(recs) < 2) next # if not at least two, skip
    
    # Try to subset into train and test
    cont = T
    recs_train = c()
    recs_test = c()
    n_test = 0
    ii = 0
    while(cont){
      ii = ii + 1
      # Test if enough testing calls
      if(n_test < N_test){
        # If not add one recording to the testing set
        recs_test = c(recs_test, sample(recs[!recs %in% recs_test], 1))
      } else {
        # If yes
        recs_train = recs[!recs %in% recs_test]
      }
      # Test if enough
      n_test = length(which(st_sub$file %in% recs_test & st_sub$main_type %in% test_set))
      n_train = length(which(st_sub$file %in% recs_train & st_sub$main_type %in% train_set))
      # Test if continue
      if(length(recs_test) == length(recs)){ # reset if not enough left
        recs_test = recs_train = c()
        n_test = 0
      } 
      if(length(recs_train) > 0 & n_train < N_train){ # reset if not enough left
        recs_test = recs_train = c()
        n_test = 0
      } 
      if(ii > max_iter) cont = F # stop if not able to resolve
      if(n_test >= N_test & n_train >= N_train){cont = F; inds_include = c(inds_include, ind)}
    }
    
    # Find names file sels
    new_names_train = st$fs[which(st$bird == ind & st$main_type %in% train_set & 
                                    st$file %in% recs_train)]
    new_names_test = st$fs[which(st$bird == ind & st$main_type %in% test_set & 
                                   st$file %in% recs_test)]
    
    # If successful save the train and test recording names
    if(ind %in% inds_include){
      
      # Test for problems
      if(any(recs_train %in% recs_test) | any(recs_test %in% recs_train)) 
        stop('Some recordings go across sets!')
      if(any(sapply(recs_test, function(rec) str_detect(new_names_train, rec))) | 
         any(sapply(recs_train, function(rec) str_detect(new_names_test, rec))) )
        stop('Some recordings go across sets!')
      if(any(!st$main_type[st$fs %in% new_names_train] %in% train_set) | 
         any(!st$main_type[st$fs %in% new_names_test] %in% test_set)) 
        stop('Wrong type in set!')
      
      # Save
      names_train = c(names_train,
                      new_names_train)
      names_test = c(names_test, 
                     new_names_test)
      
    } # end if loop
    
  } # end ind loop
  
  # Balance
  if(balance){
    names_train_slim = c()
    names_test_slim = c()
    for(ind in inds_include){
      sub_names_train = names_train[st[names_train,]$bird == ind]
      names_train_slim = c(names_train_slim, sample(sub_names_train, N_train))
      sub_names_test = names_test[st[names_test,]$bird == ind]
      names_test_slim = c(names_test_slim, sample(sub_names_test, N_test))
    }
    names_train = names_train_slim
    names_test = names_test_slim
  }
  
  # Test for problems
  if(any(names_train %in% names_test) | any(names_test %in% names_train)) 
    stop('Some calls go across sets!')
  if(any(names_train_slim %in% names_test) | any(names_test_slim %in% names_train)) 
    stop('Some calls go across sets!')
  
  return(list(names_train = names_train, 
              names_test = names_test,
              inds_include = inds_include,
              N = length(inds_include)))
  
}