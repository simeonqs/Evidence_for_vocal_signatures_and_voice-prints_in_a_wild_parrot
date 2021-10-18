# This script is to test individual results and de-bug

type = 'trruup'

i = which(str_detect(names(data_sets_spcc_time), type))[1]
plot(data_sets_spcc_dates[[i]]$date/5, data_sets_spcc_dates[[i]]$d, pch = 16, 
     col = alpha(data_sets_spcc_dates[[i]]$ind, 0.5),
     xlim = c(0, 0.2), ylim = c(-1.5, 2.5))
plot.model.time(models_spcc_time[[i]], data_sets_spcc_time[[i]])
plot.model.dates(models_spcc_dates[[i]], data_sets_spcc_dates[[i]])
if(type == call_types[1]){
  axis(2)
  mtext('accoustic distance', 2, 2, cex = 0.75)
} 
mtext(str_replace(type, '_', ' '), 3, 1, font = 2)


plot(data_sets_spcc_dates[[i]]$date[data_sets_spcc_dates[[i]]$ind<5]/5, 
     data_sets_spcc_dates[[i]]$d[data_sets_spcc_dates[[i]]$ind<5], pch = 16, 
     col = alpha(data_sets_spcc_dates[[i]]$ind[data_sets_spcc_dates[[i]]$ind<5], 0.5),
     xlim = c(0, 0.2), ylim = c(-1.5, 2.5))

