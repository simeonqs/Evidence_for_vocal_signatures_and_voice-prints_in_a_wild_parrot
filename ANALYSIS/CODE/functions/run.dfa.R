# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: voice paper
# Date started: 06-02-2022
# Date last modified: 06-02-2022
# Author: Simeon Q. Smeele
# Description: Runs DFA. 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

run.dfa = function(dat_train, # data frame with measurements only
                   dat_test, # same for testing
                   inds_train, # vector with inds
                   inds_test, # same for testing
                   random_full = F, # if true randomises labels after subsetting
                   plot_it = F){

  # Scale data
  dat_train = scale(dat_train)
  
  # Optionally randomise labels
  if(random_full) dat$inds = sample(dat$inds)
  if(random_set){
    cont = T
    while(cont){
      rec_ind = paste(dat$inds, rec) # find all recording + ind labels
      unique_rec_ind = unique(rec_ind) # get uniques
      unique_ind_rec = strsplit(unique_rec_ind, ' ') |> sapply(`[`, 1) # get ind per unique label
      shuffled = sample(unique_ind_rec) # shuffle the inds
      names(shuffled) = unique_rec_ind # give shuffled inds the original unique label
      if(min(table(shuffled[rec_ind])) < min_calls) next
      dat$inds = shuffled[rec_ind] # replace ind per label
      cont = F
    }
  }
  
  # Split data
  training_data = data.frame()
  testing_data = data.frame()
  for(ind in unique(dat$inds)){
    sub_ind = dat[dat$inds == ind,]
    testing_rows = sample(1:nrow(sub_ind), ceiling(nrow(sub_ind)/5))
    training_data = rbind(training_data,
                          sub_ind[-testing_rows,])
    testing_data = rbind(testing_data,
                         sub_ind[testing_rows,])
  }
  
  # Run DFA
  model = lda(inds ~ ., data = training_data)
  predictions = model %>% predict(testing_data)
  score = mean(predictions$class == testing_data$inds)
  if(plot_it){
    lda_data = cbind(training_data, predict(model)$x)
    print(ggplot(lda_data, aes(LD1, LD2)) +
            geom_point(aes(color = inds)))
  }
  
  # Return
  return(score)
  
} # End run.dfa
