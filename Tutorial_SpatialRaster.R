# Unduh berkas data hujan dari peladen (server)
# download.file("ftp://eclipse.ncdc.noaa.gov/pub/seawinds/SI/uv/clm/uvclm95to05.nc",
# "uvclm95to05.nc", method = "curl")
# tanpa psswd?? belum dicek!

library("raster")
library("RNetCDF")

# impor dan baca file netcdf
input <- "~/R/hujan/raw/rain/3B-DAY-E.MS.MRG.3IMERG.20140312-S000000-E235959.V05.nc4.nc4"
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
