# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 27-08-2021
# Date last modified: 23-09-2021
# Author: Simeon Q. Smeele
# Description: Plotting the output per call type. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('rethinking', 'tidyverse')
for(lib in libraries){
  if(! lib %in% installed.packages()) lapply(lib, install.packages)
  lapply(lib, require, character.only = TRUE)
}

# Clean R
rm(list=ls()) 

# Paths
path_models = 'ANALYSIS/RESULTS/mfcc/models'
path_functions = 'ANALYSIS/CODE/functions'
path_pdf = 'ANALYSIS/RESULTS/mfcc/sn results.pdf'

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Plot beta parameter per call type
pdf(path_pdf, 10, 10)
par(mfrow = c(3, 3))
for(path_model in list.files(path_models, full.names = T, pattern = '*RData')){
  load(path_model)
  name_data = path_model %>% str_remove(paste0(path_models, '/')) %>% str_remove('.RData')
  post = extract.samples(model)
  prior = rnorm(1e6, 0, 1) %>% density
  plot(prior, xlim = c(-2, 2), ylim = c(0, 5), main = name_data, 
       xlab = '', ylab = 'density')
  polygon(prior, col = alpha('grey', 0.5))
  post$b_bar_rec %>% density %>% polygon(col = alpha(2, 0.8))
  post$b_bar_ind %>% density %>% polygon(col = alpha(4, 0.8))
  text(-2, 4, sprintf('N = %s', ncol(post$z_call)), adj = 0)
}
plot(NULL, xlim = c(-1, 1), ylim = c(0, 3), xaxt = 'n', yaxt = 'n', xlab = '', ylab = '', bty = 'n')
text(c(0, 0), c(1, 2), c('beta individual', 'beta recording'), col = c(2, 4))
dev.off()