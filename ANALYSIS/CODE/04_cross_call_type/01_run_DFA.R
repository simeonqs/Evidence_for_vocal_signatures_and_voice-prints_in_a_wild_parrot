# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 06-02-2022
# Date last modified: 07-02-2022
# Author: Simeon Q. Smeele
# Description: Running DFA.  
# This version also takes recording into account. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('tidyverse', 'warbleR', 'MASS')
for(i in libraries){
  if(! i %in% installed.packages()) lapply(i, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Clean R
rm(list=ls()) 

# Paths
source('ANALYSIS/CODE/paths.R')

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Load data
load(path_data)
load(path_mfcc_out)

# Merge datasets
st_20$`complete sequence` = NA
st_20$notes = NA
st_21$notes.x = NA
st_21$notes.y = NA
st_21$...8 = NA
st = rbind(st_20, st_21)

# Add column with broad call type
source(path_call_type_classification)
st$main_type = sapply(st$`call type`, function(type){
  y = names(types_include)[sapply(types_include, function(x) type %in% x)]
  return(ifelse(length(y) == 0, NA, y))
})

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
    if(n_test < 5){
      # If not add one recording to the testing set
      rec_test = c(rec_test, sample(recs[!recs %in% rec_test], 1))
    } else {
      # If yes
      rec_train = recs[!recs %in% rec_train]
    }
    # Test if enough
    n_test = length(which(st_sub$file %in% rec_test & st_sub$main_type != 'contact'))
    n_train = length(which(st_sub$file %in% rec_train & st_sub$main_type == 'contact'))
    # Test if continue
    if(length(rec_test) == length(recs)) cont = F # stop if not enough recordings at all
    if(length(rec_train) > 0 & n_train < 10) { # reset if not enough left
      rec_test = rec_train = c()
      n_test = 0
    } 
    if(ii > 1000) cont = F # stop if able to resolve
    if(n_test > 4 & n_train > 9){cont = F; inds_include = c(inds_include, ind)}
  }
  
  # If successfull save the train and test recording names
  if(ind %in% inds_include){
    recs_train = c(recs_train, rec_train)
    recs_test = c(recs_test, rec_test)
  }
  
} # end ind loop

# Create datasets for DFA
names_train = st$fs[which(st$bird %in% inds_include & st$main_type == 'contact' & st$file %in% recs_train)]
names_test = st$fs[which(st$bird %in% inds_include & st$main_type != 'contact' & st$file %in% recs_test)]
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
print(score)
lda_data = cbind(mfcc_train, predict(model)$x)
ggplot(lda_data, aes(LD1, LD2)) +
  geom_point(aes(color = inds))

# Compare to randomised
scores_random = sapply(1:1e3, function(i) {
  mfcc_random_train = mfcc_train
  mfcc_random_train$inds = sample(mfcc_random_train$inds)
  model = lda(inds ~ ., data = mfcc_random_train)
  predictions = model %>% predict(mfcc_test)
  score_random = mean(predictions$class == mfcc_test$inds)
  return(score_random)
})
plot(density(scores_random), lwd = 3, col = 4, main = '', 
     xlab = 'proportion correct classified', ylab = 'density', xlim = c(0, 0.2))
abline(v = score, lwd = 3, lty = 2, col = 6)


