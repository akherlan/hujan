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

# Membuat Titik-titik stasiun hujan berdasar intensitas
# impor data tabular stasiun hujan
stat <- read.csv("sta.csv", header = TRUE)
stat

# ubah data tabular menjadi titik spasial
library(sp)
stap <- SpatialPoints(cbind(lon=stat$lon,lat=stat$lat),proj4string = CRS('+proj=longlat +datum=WGS84'))
showDefault(stap)

# visualisasi posisi stasiun pada koordinatnya
plot(stap, col = 'red', pch=20, cex=1.5, axes = TRUE, las = 1, main = "Stasiun Pengamatan")

# membuat data hujan secara random
prec <- load()
df <- data.frame(ID=1:nrow(stat), sta=as.character(stat$sta), precip=prec)
df

# memasukkan data.frame ke dalam vector titik stasiun
stap_df <- SpatialPointsDataFrame(stap, data=df)
showDefault(stap_df)

# visualisasi besaran hujan pada titik lokasi stasiun
plot(stap_df, col = 'blue', pch=20,  cex=1+precip/20, axes = TRUE, las = 1, main = 'Hujan')
text(stap_df, stap_df$sta, pos = 4)
