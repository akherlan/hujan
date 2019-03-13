library("RNetCDF")
library("dplyr")
library("tidyr")

# fungsi ambil tanggal dari nama file netcdf
substrTgl <- function(x, n){substr(x, nchar(x)-n, nchar(x)-n+7)}

# proses looping
lokasidata <- "~/R/hujan/raw/rain" # ganti nama folder tempat menyimpan data netcdf
daftar <- list.files(path = lokasidata, pattern = "nc4", full.names = TRUE)
text <- list.files(path = lokasidata, pattern = "nc4", full.names = FALSE)
list_prc <- vector("list", length(daftar))
names(list_prc) <- daftar
for(i in daftar){
  data <- read.nc(open.nc(i))
  prc <- as.data.frame(data$precipitationCal)
  names(prc) <- as.character(data$lon)
  row.names(prc) <- as.character(data$lat)
  prc <- mutate(prc, lat = row.names(prc))
  prc <- gather(prc, "lon", "prc", 1:5)
  # tambah tanggal
  text <- i
  tgl <- substrTgl(text, 35)
  prc <- mutate(prc, tgl = as.Date(paste(tgl), format = "%Y%m%d"))
  # masukkan data satu file ke dalam satu list
  list_prc[[i]] <- prc
}

# simpan data dalam tabel csv
prc_all <- bind_rows(list_prc)
write.csv(prc_all, file = "prc.csv", row.names = FALSE)