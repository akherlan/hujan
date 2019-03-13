# Unduh berkas data hujan dari peladen (server)
# download.file("ftp://eclipse.ncdc.noaa.gov/pub/seawinds/SI/uv/clm/uvclm95to05.nc",
# "uvclm95to05.nc", method = "curl")
# tanpa psswd?? belum dicek!

library("raster")
library("RNetCDF")

# impor dan baca file netcdf
input <- "~/R/hujan/raw/rain/3B-DAY-E.MS.MRG.3IMERG.20140312-S000000-E235959.V05.nc4.nc4" # ganti alamat datanya
file <- open.nc(input)
nc <- read.nc(file)

# memperoleh lon lat dari file netcdf dan definisikan proyeksinya
lon <- nc$lon
lat <- nc$lat
proj <- CRS("+proj=longlat +datum=WGS84")

# membuat raster data hujan
prc <- raster(nc$precipitationCal)
extent(prc) <- c(min(lon), max(lon), min(lat), max(lat))
proj4string(prc) <- proj
plot(prc)

# plot titik stasiun hujan
library("dplyr")
sta <- read.csv('sta.csv', header = TRUE) # ganti alamat file csv-nya
stasort <- slice(sta, c(1,10,12,14))
stapoin <- SpatialPoints(cbind(stasort$lon,stasort$lat),proj4string = CRS('+proj=longlat +datum=WGS84'))
plot(stapoin, pch=16, col="red", add = TRUE)

# plot batas DAS
library("rgdal")
shp <- "~/R/hujan/basin/hybas 9/hybas_lake_au_lev09_v1c.shp" # ganti alamat file shp-nya
shp <- readOGR(shp)
shp <- spTransform(shp, proj)
plot(shp, bg="transparent", add=TRUE)
