time_saver = NULL
day_saver = NULL

start = Sys.time()
d = data.frame()
for(i in 1:nrow(m)){
  if(i == ncol(m)) break
  for(j in (i+1):ncol(m)){
    new = data.frame(
      d = m[i,j],
      call_i = i,
      call_j = j,
      ind_i = inds[i],
      ind_j = inds[j],
      ind_pair = paste(inds[i], inds[j], sep = '-')
    )
    if(!is.null(recs)){
      new = cbind(new, data.frame(
        rec_i = paste(recs[i], inds[i]),
        rec_j = paste(recs[j], inds[j]),
        rec_pair = paste(recs[i], inds[i], recs[j], inds[j], sep = '-')))
    }
    if(!is.null(time_saver)) new$time = c(time_saver[i], time_saver[j]) %>% diff %>% abs %>% log10
    if(!is.null(day_saver)) new$date = c(day_saver[i], day_saver[j]) %>% diff %>% abs
    d = rbind(d, new)
  }
}
end = Sys.time()
print(end-start)



start = Sys.time()

l = nrow(m)
c = combn(1:l, 2)
d_2 = mclapply(1:ncol(c), function(x) {
  
  new = data.frame(
    d = m[c[1,x],c[2,x]],
    call_i = c[1,x],
    call_j = c[2,x],
    ind_i = inds[c[1,x]],
    ind_j = inds[c[2,x]],
    ind_pair = paste(inds[c[1,x]], inds[c[2,x]], sep = '-')
  )
  if(!is.null(recs)){
    new = cbind(new, data.frame(
      rec_i = paste(recs[c[1,x]], inds[c[1,x]]),
      rec_j = paste(recs[c[2,x]], inds[c[2,x]]),
      rec_pair = paste(recs[c[1,x]], inds[c[1,x]], recs[c[2,x]], inds[c[2,x]], sep = '-')))
  }
  if(!is.null(time_saver)) new$time = c(time_saver[c[1,x]], time_saver[c[2,x]]) %>% diff %>% abs %>% log10
  if(!is.null(day_saver)) new$date = c(day_saver[c[1,x]], day_saver[c[2,x]]) %>% diff %>% abs
  
  return(new)
  
  }, mc.cores = 4) %>% bind_rows # end running through the combinations


end = Sys.time()
print(end-start)

print(all(d_2$d == d$d))
