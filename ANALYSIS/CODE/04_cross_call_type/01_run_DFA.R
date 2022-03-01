# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 06-02-2022
# Date last modified: 18-02-2022
# Author: Simeon Q. Smeele
# Description: Running DFA.  
# This version also takes recording into account. 
# This version moves code to functions and iterates. 
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

# Run full permuted dfa
pdf(path_pdf_pdfa, 10, 10)
par(mfrow = c(2, 2))
run.pdfa(train_set = 'contact', 
         test_set = c('growl', 'alarm', 'growl_low', 'trruup'),
         main = 'contact to growly')
run.pdfa(train_set = c('growl', 'alarm', 'growl_low', 'trruup'), 
         test_set = 'contact',
         main = 'growly to contact')
run.pdfa(train_set = 'contact', 
         test_set = 'contact', 
         main = 'contact to contact')
run.pdfa(train_set = c('growl', 'alarm', 'growl_low', 'trruup'), 
         test_set = c('growl', 'alarm', 'growl_low', 'trruup'), 
         main = 'growly to growly')
dev.off()




