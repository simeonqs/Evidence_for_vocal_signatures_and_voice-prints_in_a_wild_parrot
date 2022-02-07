# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 06-02-2022
# Date last modified: 06-02-2022
# Author: Simeon Q. Smeele
# Description: Running DFA.  
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

# Subset st for individuals with at least 10 contact calls and 10 non-contact calls
inds = unique(st$bird)
contacts_per_ind = sapply(inds, function(ind) nrow(st[st$bird == ind & st$main_type == 'contact',]))
other_per_ind = sapply(inds, function(ind) nrow(st[st$bird == ind & st$main_type != 'contact',]))
inds_include = inds[contacts_per_ind >= 10 & other_per_ind >= 10]

# Create datasets for DFA
names_train = st$fs[which(st$bird %in% inds_include & st$main_type == 'contact')]
names_test = st$fs[which(st$bird %in% inds_include & st$main_type != 'contact')]
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
if(plot_it){
  lda_data = cbind(mfcc_train, predict(model)$x)
  print(ggplot(lda_data, aes(LD1, LD2)) +
          geom_point(aes(color = inds)))
}

