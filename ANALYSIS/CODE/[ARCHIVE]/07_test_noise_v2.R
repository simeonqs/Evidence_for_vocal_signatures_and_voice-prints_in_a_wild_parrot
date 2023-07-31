# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: complexity paper
# Date started: 27-03-2023
# Date last modified: 27-03-2023
# Author: Simeon Q. Smeele
# Description: Create noise clips for each call. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('warbleR')
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
load(path_data)

# Remove files that have already been done
ad = list.files(path_noise_files_sorted) |> strsplit('-')
ad = vapply(ad, function(x) paste(x[1], x[2], sep = '-'), character(1))
st = st[!st$fs %in% ad,]

# Loop through selections to create noise
for(i in sample(nrow(st))){
  
  # Load before or after
  from = st$Begin.Time..s.[i]
  to = st$End.Time..s.[i]
  dur = to - from + 0.05 # add 0.05 to remove echo after call
  sign = sample(c(-1, 1), 1)
  from = from - sign * dur
  to = to - sign * dur
  path_audio = ifelse(str_detect(st$file[i], '2020'), path_audio_20, path_audio_21)
  wave = load.wave(path_audio_file = paste0(path_audio, '/', st$file[i], '.wav'), 
                   from = from,
                   to = to)
  
  # Plot and ask for input
  cont = TRUE
  while(cont){
    if(mean(abs(wave@left)) < 1200){ # test if to loud (= noisy)
      pdf(paste0(path_noise_files_unsorted, '/', st$fs[i], '-', from , '-', to, '.pdf'))
      better.spectro(wave, ylim = c(0, 10000))
      dev.off()
      cont = FALSE
    } else { # else try another selection
      from = from - sign * dur
      to = to - sign * dur
      wave = load.wave(path_audio_file = paste0(path_audio, '/', st$file[i], '.wav'), 
                       from = from,
                       to = to)
    }
  }
  
} # end i loop
