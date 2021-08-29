# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: monk parakeets
# Date started: 27-04-2021
# Date last modified: 27-08-2021
# Author: Simeon Q. Smeele
# Description: Loads the call type and context file and fills out missing rows. 
# This version was moved to the new repo and an fs column is added. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

load.call.type.context = function(path_file){
  
  dat_orig = read_xlsx(path_file) %>% as.data.frame
  dat = data.frame()
  for(i in 1:nrow(dat_orig)){
    split = strsplit(dat_orig$selection[i], 't')[[1]] %>% as.numeric
    if(length(split) == 2) s = seq(split[1], split[2]) else s = split
    new = data.frame()
    for(j in 1:length(s)) new = rbind(new, dat_orig[i,])
    new$selection = s
    dat = rbind(dat, new)
  }
  dat$fs = paste(str_remove(dat$file, '.Table.1.selections.txt'), dat$selection, sep = '-')
  
  return(dat)
  
}