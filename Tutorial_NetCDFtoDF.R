library(RNetCDF)
library(dplyr)

# impor data dari file netcdf
file <- "~/R/hujan/raw/trmm/3B42_Daily.20090101.7.nc4"
fid <- open.nc(file)
print.nc(fid)
data <- read.nc(fid)

# dapatkan nilai hujan dan koordinat
prc <- as.data.frame(data$precipitation)
xlon <- as.character(data$lon)
ylat <- as.character(data$lat)

# menamai baris dan kolom
names(prc) <- xlon
row.names(prc) <- ylat

prc