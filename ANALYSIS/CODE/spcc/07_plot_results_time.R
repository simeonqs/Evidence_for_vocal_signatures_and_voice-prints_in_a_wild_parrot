# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 27-08-2021
# Date last modified: 28-09-2021
# Author: Simeon Q. Smeele
# Description: Plotting the output per call type including time. 
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
path_models = 'ANALYSIS/RESULTS/spcc/models time'
path_functions = 'ANALYSIS/CODE/functions'
path_pdf = 'ANALYSIS/RESULTS/spcc/sn results time.pdf'

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
  post$b_bar_rec %>% density %>% polygon(col = alpha(2, 0.6)) # red
  post$b_bar_ind %>% density %>% polygon(col = alpha(4, 0.6)) # blue
  post$b_bar_time %>% density %>% polygon(col = alpha(3, 0.6)) # green
  text(-2, 4, sprintf('N = %s', ncol(post$z_call)), adj = 0)
}
plot(NULL, xlim = c(-1, 1), ylim = c(0, 3), xaxt = 'n', yaxt = 'n', xlab = '', ylab = '', bty = 'n')
text(c(0, 0), c(1, 2), c('beta individual', 'beta recording'), col = c(2, 4))
dev.off()

# Plot line on data

test = data.frame(time = clean_dat$time[clean_dat$same_rec[clean_dat$rec_pair] == 1],
                  dist = clean_dat$d[clean_dat$same_rec[clean_dat$rec_pair] == 1])
plot(test$time, test$dist, col = alpha(1, 0.4))

summary(glm(dist ~ time, dat = test))

x = seq(0, 0.2, length.out = 100)
lines(x, -1+ 2*x^0.2, col = 2)
lines(x, -1 + exp(0.1*log(x)), col = 3)


