# Muat data
precip <- read.csv("~/R/work/precip.csv", header=TRUE)
head(precip)

# Membuat SpatialPointsDataFrame dan transformasikan ke *lokasi
library(sp)
coordinates(precip) <- ~ lon + lat
proj4string(precip) <- CRS('+proj=longlat +ellps=WGS84')
java <- CRS("+proj=longlat +ellps=bessel +pm=jakarta +no_defs")
library(rgdal)
aq <- spTransform(precip, java)

gs_prc <- gstat(formula=prc~1)
v <- variogram(gs_prc, width=20)
