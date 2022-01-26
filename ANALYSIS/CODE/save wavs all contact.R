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
path_out = 'ANALYSIS/RESULTS/contact call sorting'

# Load data
load(path_data)
load(path_waves)

# Subset for contact calls
source(path_call_type_classification)
st = st[st$`call type` %in% types_include$contact,]

# Get behaviours and subset for isolation calls
st = st[which(st$context == 'single'),]
st = st[which(!st$location %in% c('grass', 'ground')),]
st = st[!is.na(st$behaviour),]
st = st[!str_detect(st$behaviour, 'response'),]
st = st[!str_detect(st$behaviour, 'responding'),]
st = st[!str_detect(st$behaviour, 'foraging'),]
st = st[!str_detect(st$behaviour, 'in beak'),]
st = st[!str_detect(st$behaviour, 'foraing'),]
st = st[!str_detect(st$behaviour, 'feeding'),]
st = st[!str_detect(st$behaviour, 'chewing on leaves'),]
st = st[!str_detect(st$behaviour, 'flying down to ground'),]
st = st[!str_detect(st$behaviour, 'flying down to the groundm'),]
st = st[!str_detect(st$behaviour, 'chewing branch'),]
unique_behaviours = st$behaviour %>% 
  str_split(', ') %>% 
  unlist %>% 
  str_remove(' in') %>%
  unique

# Save wavs
for(i in 1:nrow(st)) writeWave(waves[st$fs[i]][[1]], 
                               sprintf('%s/%s.wav', path_out, st$fs[i]), 
                               extensible = F) 
