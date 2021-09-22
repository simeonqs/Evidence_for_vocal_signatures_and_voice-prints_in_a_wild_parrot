# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 27-08-2021
# Date last modified: 07-09-2021
# Author: Simeon Q. Smeele
# Description: Plotting the output per call type. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('rethinking', 'tidyverse')
for(lib in libraries){
  if(! lib %in% installed.packages()) lapply(lib, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Clean R
rm(list=ls()) 

# Paths
path_models = 'ANALYSIS/RESULTS/spcc/models'
path_functions = 'ANALYSIS/CODE/functions'
path_pdf = 'ANALYSIS/RESULTS/spcc/sn results.pdf'

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Plot beta parameter per call type
# pdf(path_pdf, 10, 10)
par(mfrow = c(3, 3))
for(path_model in list.files(path_models, full.names = T, pattern = '*RData')){
  load(path_model)
  name_data = path_model %>% str_remove(paste0(path_models, '/')) %>% str_remove('.RData')
  post = extract.samples(model)
  prior = rnorm(1e6, 0, 1) %>% density
  plot(prior, xlim = c(-2, 2), ylim = c(0, 5), main = name_data, 
       xlab = '', ylab = 'density')
  polygon(prior, col = alpha('grey', 0.5))
  post$b_bar %>% density %>% polygon(col = alpha(4, 0.8))
}
# dev.off()



