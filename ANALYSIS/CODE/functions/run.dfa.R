# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 15-02-2022
# Date last modified: 09-05-2022
# Author: Simeon Q. Smeele
# Description: Running DFA. Assumes multiple objects are loaded, very specific to this chapter. 
# This version has to option to randomise within nesting locations. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

run.dfa = function(names_train, names_test, mfcc_out, permute = F, print_scaling = T){
  
  # Prepare data
  mfcc_scale = scale(bind_rows(mfcc_out))
  rownames(mfcc_scale) = names(mfcc_out)
  mfcc_train = as.data.frame(mfcc_scale[names_train,])
  mfcc_test = as.data.frame(mfcc_scale[names_test,])
  mfcc_train$inds = st[names_train,]$bird
  mfcc_test$inds = st[names_test,]$bird
  
  # Test for problems
  if(! nrow(mfcc_train) == length(names_train) |
     ! nrow(mfcc_test) == length(names_test)) stop('Dimensions do not match!')
  
  # Run DFA
  model = lda(inds ~ ., data = mfcc_train)
  predictions = model %>% predict(mfcc_test)
  score = mean(predictions$class == mfcc_test$inds)
  # print(score)
  lda_data = cbind(mfcc_train, predict(model)$x)
  # print(ggplot(lda_data, aes(LD1, LD2)) +
  #         geom_point(aes(color = inds)))
  
  # Save scaling
  scaling = model$scaling
  first = names(which(abs(scaling[,1]) == max(abs(scaling[,1]))))
  
  # Do randomised
  mfcc_random_train = mfcc_train
  mfcc_random_test = mfcc_test
  if(permute){
    for(n in unique(st$nesting)){
      mfcc_random_train$inds[st[names_train,]$nesting == n] = 
        sample(mfcc_random_train$inds[st[names_train,]$nesting == n])
      mfcc_random_test$inds[st[names_test,]$nesting == n] = 
        sample(mfcc_random_test$inds[st[names_test,]$nesting == n])
    }
  } else {
    mfcc_random_train$inds = sample(mfcc_random_train$inds)
    mfcc_random_test$inds = sample(mfcc_random_test$inds)
  }
  model = lda(inds ~ ., data = mfcc_random_train)
  predictions = model %>% predict(mfcc_random_test)
  score_random = mean(predictions$class == mfcc_random_test$inds)
  
  return(list(score = score, 
              score_random = score_random,
              score_diff = score - score_random,
              most_important = first))
  
}