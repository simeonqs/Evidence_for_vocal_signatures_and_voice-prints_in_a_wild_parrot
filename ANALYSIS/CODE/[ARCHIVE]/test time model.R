# Loading libraries
libraries = c('rethinking', 'tidyverse')
for(lib in libraries){
  if(! lib %in% installed.packages()) lapply(lib, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Clean R
rm(list=ls()) 

# Paths
source('ANALYSIS/CODE/paths.R')

# Import functions
.functions = sapply(list.files(path_functions, pattern = '*R', full.names = T), source)

# Load data
load(path_time_model_results)
load(path_data_sets_time)

dat = data_sets_time$spcc$loud_contact

plot(dat$time, dat$d, pch = 16, col = alpha('purple', 0.3))

plot(log(dat$time), dat$d, pch = 16, col = alpha('purple', 0.3))


# Test the model
x = dat$time
y = dat$d
fit = lm(y ~ x)
summary(fit)
plot(x, y)
abline(fit, col = 2, lwd = 3)
fit_log = lm(y ~ log(x))
summary(fit_log)
xs = seq(0, 0.2, 0.001)
ys = fit_log$coefficients[1] + log(xs) * fit_log$coefficients[2]
lines(xs, ys, col = 3, lwd = 3)

# Single id
table(dat$ind)
x = dat$time[dat$ind == 9]
y = dat$d[dat$ind == 9]
plot(x, y)
fit = lm(y ~ x)
summary(fit)
abline(fit, col = 1, lwd = 3)
fit_log = lm(y ~ log(x))
summary(fit_log)
xs = seq(0, 0.2, 0.001)
ys = fit_log$coefficients[1] + log(xs) * fit_log$coefficients[2]
lines(xs, ys, lwd = 3, lty = 2)

# plot(log(x), y)

x = dat$time[dat$ind == 6]
y = dat$d[dat$ind == 6]
points(x, y, col = 2)
fit = lm(y ~ x)
summary(fit)
abline(fit, col = 2, lwd = 3)
fit_log = lm(y ~ log(x))
summary(fit_log)
xs = seq(0, 0.2, 0.001)
ys = fit_log$coefficients[1] + log(xs) * fit_log$coefficients[2]
lines(xs, ys, lwd = 3, lty = 2, col = 2)
