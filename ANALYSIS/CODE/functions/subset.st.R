# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 28-01-2022
# Date last modified: 28-01-2022
# Author: Simeon Q. Smeele
# Description: Subsets the selection table for a year and removes all calls without traces. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

subset.st = function(st, year, traces){
  
  # Subset for year
  st = st[str_detect(st$file, year),]
  
  # Remove all calls that are not in Luscinia and print them
  traces$fs = str_remove(traces$Song, '.wav')
  not_luscinia = unique(st$fs[!st$fs %in% traces$fs])
  message(sprintf('Missing %s calls in Luscinia, showing first six', length(not_luscinia)))
  print(head(not_luscinia))
  st = st[!st$fs %in% not_luscinia,]
  
  # Names rows
  rownames(st) = st$fs
  
  # Run checks
  if(any(is.na(st$bird))) stop('Missing IDs!')
  
  # Return
  message(sprintf('Returning subsetted st with %s rows.', nrow(st)))
  return(st)
  
}
