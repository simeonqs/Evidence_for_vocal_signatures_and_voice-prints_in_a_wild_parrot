# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 15-02-2022
# Date last modified: 12-03-2022
# Author: Simeon Q. Smeele
# Description: Running DFA. Assumes multiple objects are loaded, very specific to this chapter. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

run.dfa = function(names_train, names_test, mfcc_out){
  
  # Prepare data
  mfcc_scale = scale(bind_rows(mfcc_out))
  rownames(mfcc_scale) = names(mfcc_out)
  mfcc_train = as.data.frame(mfcc_scale[names_train,])
  mfcc_test = as.data.frame(mfcc_scale[names_test,])
  mfcc_train$inds = st[names_train,]$bird
  mfcc_test$inds = st[names_test,]$bird
  
  # Run DFA
  model = lda(inds ~ ., data = mfcc_train)
  predictions = model %>% predict(mfcc_test)
  score = mean(predictions$class == mfcc_test$inds)
  # print(score)
  lda_data = cbind(mfcc_train, predict(model)$x)
  # print(ggplot(lda_data, aes(LD1, LD2)) +
  #         geom_point(aes(color = inds)))
  
  # Do randomised
  mfcc_random_train = mfcc_train
  mfcc_random_train$inds = sample(mfcc_random_train$inds)
  mfcc_random_test = mfcc_test
  mfcc_random_test$inds = sample(mfcc_random_test$inds)
  model = lda(inds ~ ., data = mfcc_random_train)
  predictions = model %>% predict(mfcc_random_test)
  score_random = mean(predictions$class == mfcc_random_test$inds)
  
  return(c(score = score, 
           score_random = score_random,
           score_diff = score - score_random))
  
}