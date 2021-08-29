# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: chapter II
# Date started: 27-08-2021
# Date last modified: 27-08-2021
# Author: Simeon Q. Smeele
# Description: Prepares the data into matrices and runs a partial mantel test. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

require(vegan)

run.partial.mantel = function(path_data_set){
  
  load(path_data_set)
  
  l = nrow(d_sub)
  m_ind = matrix(NA, nrow = l, ncol = l)
  for(row in 1:l)
    for(col in 1:l)
      m_ind[row, col] = ifelse(d_sub$ind[row] == d_sub$ind[col], 0, 1)
  diag(m_ind) = NA

  m_rec_ind = matrix(NA, nrow = l, ncol = l)
  for(row in 1:l)
    for(col in 1:l)
      m_rec_ind[row, col] = ifelse(d_sub$file[row] == d_sub$file[col] & 
                                     d_sub$ind[row] == d_sub$ind[col], 0, 1)
  diag(m_rec_ind) = NA
  
  partial_mantel_out = mantel.partial(m_sub, 
                                      m_ind, 
                                      m_rec_ind,
                                      method = 'pearson', permutations = 1000, 
                                      strata = NULL, na.rm = TRUE, parallel = 4)
  
}