# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 28-01-2022
# Date last modified: 28-01-2022
# Author: Simeon Q. Smeele
# Description: Creating the datasets per call type from the st. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

create.data.sets = function(st, path_call_type_classification, path_sorted_loud_contact = NULL){

  source(path_call_type_classification)
  
  data_sets = lapply(names(types_include), function(type) st$fs[st$`call type` %in% types_include[[type]]])
  names(data_sets) = names(types_include)
  if(!is.null(path_sorted_loud_contact)){
    loud_contact = path_sorted_loud_contact %>% list.files('*wav') %>% str_remove('.wav')
    loud_contact = loud_contact[loud_contact %in% data_sets$contact]
    data_sets$loud_contact = loud_contact
  }
  
  message('Returning ', length(data_sets), ' datasets.')
  return(data_sets)
  
}
