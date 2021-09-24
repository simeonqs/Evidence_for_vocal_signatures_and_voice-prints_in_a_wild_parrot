# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: chapter II
# Date started: 16-02-2021
# Date last modified: 24-08-2021
# Author: Simeon Q. Smeele
# Description: Started code for chapter I. Detects max amplitude section of wave. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

wave.detec = function(selection_table, 
                      path_audio, 
                      threshold = 0.4, 
                      bp = 1, 
                      msmooth = c(2000, 90),
                      progress_bar = T){
  
  if(progress_bar) pb = txtProgressBar(min = 0, max = nrow(selection_table), initial = 0, style = 3)
  
  for(i in 1:nrow(selection_table)){
    
    if(progress_bar) setTxtProgressBar(pb,i)
    
    # Load wave
    wave = readWave(paste0(path_audio, '/', selection_table$file[i], '.wav'),
                    from = selection_table$Begin.Time..s.[i],
                    to = selection_table$End.Time..s.[i], 
                    unit = 'seconds')
    wave = ffilter(wave, from = bp[1]*1000, to = NULL, bandpass = TRUE,
                   custom = NULL, wl = 512, ovlp = 90, wn = "hanning", fftw = FALSE,
                   rescale=FALSE, listen=FALSE, output="Wave")
    
    # Envelope
    env = env(wave, msmooth = msmooth, plot = F) 
    env = ( env - min(env) ) / max( env - min(env) )
    
    # Find max location
    where.max = which(env == 1)
    
    # Left loop
    start = NA
    j = where.max
    while(is.na(start)){
      j = j - 1
      if(j == 0) start = j else if(env[j] < threshold) start = j
    } 
    
    # Right loop
    end = NA
    j = where.max
    while(is.na(end)){
      if(j == length(env)){end = j; next}
      j = j + 1
      if(j == length(env)) end = j else if(env[j] < threshold) end = j
    } 
    
    # Test spectrogram
    if(F){
      plot(env)
      abline(v = c(start, end))
      better.spectro(wave)
      duration = selection_table$End.Time..s.[i] - selection_table$Begin.Time..s.[i]
      abline(v = start * duration/length(env))
      abline(v = end * duration/length(env))
    }
    
    # Update selection table
    duration = selection_table$End.Time..s.[i] - selection_table$Begin.Time..s.[i]
    selection_table$End.Time..s.[i] = selection_table$Begin.Time..s.[i] + end * duration/length(env)
    selection_table$Begin.Time..s.[i] = selection_table$Begin.Time..s.[i] + start * duration/length(env)
    
  } # End for loop i
  
  if(progress_bar) close(pb)
  
  # Return
  return(selection_table)
  
} # End wave.detec
