# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 12-05-2022
# Date last modified: 12-05-2022
# Author: Simeon Q. Smeele
# Description: Running random forest. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

run.rf = function(names_train, names_test, mfcc_out, permute = F, print_scaling = T){
  
  # Prepare data
  mfcc_scale = scale(bind_rows(mfcc_out))
  rownames(mfcc_scale) = names(mfcc_out)
  mfcc_train = as.data.frame(mfcc_scale[names_train,])
  mfcc_test = as.data.frame(mfcc_scale[names_test,])
  mfcc_train$inds = as.factor(st[names_train,]$bird)
  mfcc_test$inds = as.factor(st[names_test,]$bird)
  
  # Run random forest
  rf = randomForest(inds ~ ., data = mfcc_train, proximity = TRUE) 
  p = predict(rf, mfcc_test)
  cm = confusionMatrix(p, mfcc_test$inds)
  score = as.numeric(cm$overall[1])
  
  # Random random forest
  mfcc_random_train = mfcc_train
  mfcc_random_test = mfcc_test
  mfcc_random_train$inds = sample(mfcc_random_train$inds)
  mfcc_random_test$inds = sample(mfcc_random_test$inds)
  rf = randomForest(inds ~ ., data = mfcc_random_train, proximity = TRUE) 
  p = predict(rf, mfcc_random_test)
  cm = confusionMatrix(p, mfcc_random_test$inds)
  score_random = as.numeric(cm$overall[1])
  
  return(list(score = score, 
              score_random = score_random,
              score_diff = score - score_random))
  
}