library(RNetCDF)
library(dplyr)

# impor data dari file netcdf
file <- "~/R/hujan/raw/"
fid <- open.nc(file)
print.nc(fid)
data <- read.nc(fid)

# dapatkan nilai hujan dan koordinat
prc <- data$precipitation
xlon <- as.character(data$nlon)
ylat <- as.character(data$nlat)

# menamai baris dan kolom
names(prc) <- xlon
row.names(prc) <- ylat