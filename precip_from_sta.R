# ingin menggabungkan data hujan dari sta yang terpecah-pecah
files <- list.files(getwd())
for (i in files) {
  load(i)
}
remove(files,i)
a <- ls()
precip <- vector("list", length(a))
names(precip) <- a
for (i in a){
  precip[[i]] <- i
}