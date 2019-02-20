# Muat data
x <- sp_data("airqual.csv")
head(x[,c(2,4:5,26)])
x$OZDLYAV <- x$OZDLYAV * 1000

# Membuat SpatialPointsDataFrame dan transformasikan ke *lokasi
library(sp)
coordinates(x) <- ~ LONGITUDE + LATITUDE
proj4string(x) <- CRS('+proj=longlat +datum=NAD83')
TA <- CRS("+proj=aea +lat_1=34 +lat_2=40.5 +lat_0=0 +lon_0=-120 +x_0=0 +y_0=-4000000 +datum=NAD83 +units=km +ellps=GRS80")
library(rgdal)
aq <- spTransform(x, TA)

# Peta tempat plot
cageo <- sp_data('counties.rds')
ca <- spTransform(cageo, TA)
r <- raster(ca)
res(r) <- 10 # 10 km if your CRS's units are in km
g <- as(r, 'SpatialGrid')

# Use gstat to create an emperical variogram 'v'
library(gstat)
gs <- gstat(formula=OZDLYAV~1, locations=aq)
v <- variogram(gs, width=40)
head(v)
plot(v)

# Fitting ke variogram teoritis 'Exponential'
fve <- fit.variogram(v, vgm(85, "Exp", 75, 20))
fve
plot(variogramLine(fve, 400), type='l', ylim=c(0,120))
points(v[,2:3], pch=20, col='red')

# Coba tipe lain 'Spherical'
fvs <- fit.variogram(v, vgm(85, "Sph", 75, 20))
fvs
plot(variogramLine(fvs, 400), type='l', ylim=c(0,120) ,col='blue', lwd=2)
points(v[,2:3], pch=20, col='red')

# Plot variogram dengan gaya berbeda
plot(v, fve)
