library("RNetCDF")
library("dplyr")
library("tidyr")

# fungsi "ambil tanggal" dari nama file netcdf
substrTgl <- function(x, n){substr(x, nchar(x)-n, nchar(x)-n+7)}

setwd(dir = "~/R/hujan/")
lokasidata <- "prc/TRMM_3B42RT_Daily_V7" # ganti nama folder tempat menyimpan data netcdf
daftar <- list.files(path = lokasidata, pattern = "nc4", full.names = TRUE)
list_prc <- vector("list", length(daftar))
names(list_prc) <- daftar
for(i in daftar){
  data <- read.nc(open.nc(i))
  prc <- as.data.frame(data$precipitation)
  names(prc) <- as.character(data$lon)
  row.names(prc) <- as.character(data$lat)
  prc <- mutate(prc, lat = row.names(prc))
  prc <- gather(prc, "lon", "prc", 1:3)
  # tambah tanggal
  text <- i
  tgl <- substrTgl(text, 17)
  prc <- mutate(prc, tgl = as.Date(paste(tgl), format = "%Y%m%d"))
  prc$lat <- as.numeric(prc$lat)
  prc$lon <- as.numeric(prc$lon)
  # masukkan data satu file ke dalam satu list
  list_prc[[i]] <- prc
}

# simpan data dalam tabel csv
prc_bind <- bind_rows(list_prc)
write.csv(prc_bind, file = "prc.csv", row.names = FALSE)