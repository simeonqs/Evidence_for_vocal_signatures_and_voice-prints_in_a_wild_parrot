# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: monk parakeets
# Date started: 10-12-2020
# Date last modified: 26-08-2021
# Author: Simeon Q. Smeele
# Description: Loads selection tables made in Raven and outputs them binded into a dataframe. 
# This version fixes a problem where there were more than eight columns. 
# This version includes the option to merge the annotations onto the selection tables. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

load.selection.tables = function(path_selection_tables,
                                 path_annotations = NULL # if included annotations are merged on
                                 ){
  
  if(!is.character(path_selection_tables)) 
    stop(paste0('Not a character. This function only takes one argument:',
                'the path to the folder containing the .txt files from Raven.'))
  
  selection_tables = path_selection_tables %>% 
    list.files('*txt', full.names = T) %>% 
    lapply(function(x){
      temp = read.csv(x, sep = '\t')
      if(ncol(temp) != 8){ # if there are decibel columns, make sure it still works
        temp = read.csv(x, sep = '\t', colClasses = c('numeric', 'character', 'numeric', 'numeric', 'numeric', 
                                                      'numeric', 'numeric', 'character', 'character', 'character', 
                                                      'character'))
        temp = temp[,colnames(temp) %in% c('Selection', 'View', 'Channel', 'Begin.Time..s.', 'End.Time..s.', 
                                           'Low.Freq..Hz.', 'High.Freq..Hz.', 'Delta.Time..s.', 'Annotation')]
      } else {
        temp = read.csv(x, sep = '\t', colClasses = c('numeric', 'character', 'numeric', 'numeric', 'numeric', 
                                                      'numeric', 'numeric', 'character'))
      }
      return(temp)
    })
  names(selection_tables) = path_selection_tables %>% 
    list.files('*txt') %>% str_remove('.Table.1.selections.txt')
  dat = selection_tables %>%
    bind_rows(.id = 'file')
  dat = dat[dat$View == 'Waveform 1',]
  
  # Merge annotations
  if(!is.null(path_annotations)){
    annotations = read.csv2(path_annotations)
    dat = merge(dat, annotations, by.x = 'Annotation', by.y = 'annotation_ref',
                all.x = T, all.y = F)
  }
  
  return(dat)
  
}
