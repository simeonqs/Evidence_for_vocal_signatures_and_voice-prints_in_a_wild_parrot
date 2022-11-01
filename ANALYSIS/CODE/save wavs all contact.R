# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 28-02-2022
# Date last modified: 28-02-2022
# Author: Simeon Q. Smeele
# Description: Saving contact calls so that they can be sorted into loud contact calls and others. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('tidyverse', 'warbleR')
for(lib in libraries){
  if(! lib %in% installed.packages()) lapply(lib, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Clean R
rm(list=ls()) 

# Paths
source('ANALYSIS/CODE/paths.R')
path_out = 'ANALYSIS/RESULTS/contact call sorting 20'

# Load data
load(path_data)
load(path_waves)

# Subset for contact calls
source(path_call_type_classification)
# st_21 = st_21[st_21$`call type` %in% types_include$contact,]
# 
# # Get behaviours and subset for isolation calls
# st_21 = st_21[which(st_21$context == 'single'),]
# st_21 = st_21[which(!st_21$location %in% c('grass', 'ground')),]
# st_21 = st_21[!is.na(st_21$behaviour),]
# st_21 = st_21[!st_21r_detect(st_21$behaviour, 'response'),]
# st_21 = st_21[!st_21r_detect(st_21$behaviour, 'responding'),]
# st_21 = st_21[!st_21r_detect(st_21$behaviour, 'foraging'),]
# st_21 = st_21[!st_21r_detect(st_21$behaviour, 'in beak'),]
# st_21 = st_21[!st_21r_detect(st_21$behaviour, 'foraing'),]
# st_21 = st_21[!st_21r_detect(st_21$behaviour, 'feeding'),]
# st_21 = st_21[!st_21r_detect(st_21$behaviour, 'chewing on leaves'),]
# st_21 = st_21[!st_21r_detect(st_21$behaviour, 'flying down to ground'),]
# st_21 = st_21[!st_21r_detect(st_21$behaviour, 'flying down to the groundm'),]
# st_21 = st_21[!st_21r_detect(st_21$behaviour, 'chewing branch'),]
# unique_behaviours = st_21$behaviour %>% 
#   st_21r_split(', ') %>% 
#   unlist_21 %>% 
#   st_21r_remove(' in') %>%
#   unique
# 
# # Save wavs
# for(i in 1:nrow(st_21)) writeWave(waves[st_21$fs[i]][[1]], 
#                                sprintf('%s/%s.wav', path_out, st_21$fs[i]), 
#                                extensible = F) 

# Now doing 2020
st = st_20[which(st_20$`call type` == 'contact'),]
st = st[st$context == 'isolated',]
st = st[st$behaviour %in% c('perched', 'perched, calls in background', 'perched, looking around',
                            'perched nest tree, looking around', 'at nest', 'perched nest tree'),]

# Save wavs
for(i in 1:nrow(st)) writeWave(waves_20[st$fs[i]][[1]],
                               sprintf('%s/%s.wav', path_out, st$fs[i]),
                               extensible = F)
