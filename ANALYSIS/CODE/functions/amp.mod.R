# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: monk parakeets
# Date started: 19-10-2021
# Date last modified: 19-10-2021
# Author: Simeon Q. Smeele
# Description: Measures amplitude modulation. 
# This version was fixed for the case there were no minis. Previous solution didn't work. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

amp.mod = function(wave, 
                   msmooth = c(1000, 90)){
  
  # Idea is that we can cut a vocalisation at the angle change in the bottom, if you smoothen enough 
  # (works well for i = 1)
  env = env(wave, msmooth = c(400, 30), plot = F) # taking envelope of the wave
  env = env/max(env)
  
  # Run through points of envelope and calculate difference between local minima and maxima
  maxes = c()
  minis = c()
  direction = "up"
  for(i in 2:length(env)){
    
    # If going down and previous going up, save previous as max
    if(env[i] < env[i-1] & # if current is smaller than previous it's going down
       direction == 'up'){direction = 'down'; maxes = c(maxes, i-1)}
    
    # If going up and previous going down, save previous as min
    if(env[i] > env[i-1] & # if current is larger than previous it's going up
       direction == 'down'){direction = 'up'; minis = c(minis, i-1)}
    
  } # End for loop i
  
  # Remove last mini if there are too many
  if(length(minis) == length(maxes)) minis = minis[-length(minis)]
  
  # Calculate differences
  # If no mini diff = 0
  if(length(minis) == 0) diff = 0 else{
    diff = c()
    for(i in 1:length(minis)){
      diff = c(diff,
               mean(env[maxes[i]] - env[minis[i]], env[maxes[i+1]] - env[minis[i]]))
    }
  }
  
  # Calculate exact time maxes
  duration_wave = length(wave@left)/wave@samp.rate
  n_samp_env = length(env[,1])
  time_per_samp = duration_wave/n_samp_env
  exact.maxes = rep(NA, length(maxes))
  for(i in 1:(length(minis)+1)){
    if(i == 1) s = 0 else s = round(minis[i-1]*time_per_samp*wave@samp.rate)
    if(i > length(minis)) e = length(wave@left) else e = round(minis[i]*time_per_samp*wave@samp.rate)
    new_env = env(wave[s:e], msmooth = c(100, 80), plot = F)
    new_duration_wave = length(wave[s:e]@left)/wave@samp.rate
    new_n_samp_env = length(new_env[,1])
    new_time_per_samp = new_duration_wave/new_n_samp_env
    exact.maxes[i] = s/wave@samp.rate + which(new_env == max(new_env))*new_time_per_samp
  }
  
  # Calculate internote interval
  saver = rep(NA, length(exact.maxes)-1)
  for(i in 2:length(exact.maxes)){
    saver[i-1] = exact.maxes[i] - exact.maxes[i-1]
  } 
  
  # Plot results
  if(F){ # envelope
    plot(env, type = 'b')
    abline(v = maxes, col = 2, lty = 2)
    abline(v = minis, col = 3, lty = 2)
  }
  if(F){ # spectrogram
    better.spectro(wave)
    abline(v = exact.maxes, col = 1, lty = 2)
  }
  
  # Return data
  return(data.frame(nr.notes = length(maxes),
                    amp.mod.med = median(diff),
                    # tops.iqr = IQR(env[maxes]),
                    internote.med = median(saver)# ,
                    #internote.iqr = IQR(saver)
                    ))
  
} 