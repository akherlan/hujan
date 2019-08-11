# Unduh berkas data hujan dari peladen (server)
# download.file("ftp://eclipse.ncdc.noaa.gov/pub/seawinds/SI/uv/clm/uvclm95to05.nc",
# "uvclm95to05.nc", method = "curl")
# tanpa psswd?? belum dicek!

# impor dan baca file netcdf
library("RNetCDF")
input <- "prc/TRMM_3B42RT_Daily_V7/3B42RT_Daily.20000301.7.nc4.nc4" # ganti alamat datanya
file <- open.nc(input)
nc <- read.nc(file)

# memperoleh lon lat dari file netcdf dan definisikan proyeksinya
lon <- nc$lon
lat <- nc$lat
proj <- CRS("+proj=longlat +datum=WGS84")

# membuat raster data hujan
library("raster")
prc <- raster(nc$precipitation)
extent(prc) <- c(min(lon), max(lon), min(lat), max(lat)) # barat, timur, selatan, utara
proj4string(prc) <- proj
plot(prc, main = "2000-03-01")

# plot titik stasiun hujan
library("dplyr")
sta <- read.csv('sta.csv', header = TRUE) # ganti alamat file csv-nya
# stasort <- slice(sta, c(1,10,12,14)) # mensortir stasiun
stapoin <- SpatialPoints(cbind(lon=sta$lon,lat=sta$lat), proj4string = CRS('+proj=longlat +datum=WGS84'))
plot(stapoin, pch=16, col="red", add = TRUE)

# plot batas DAS
library("rgdal")
shp <- "basin/ciliwung/ciliwung.shp" # ganti alamat file shp-nya
shp <- readOGR(shp)
shp <- spTransform(shp, proj)
plot(shp, bg="transparent", add=TRUE)
showDefault(shp)
