library(sp)
library(rgdal)
library(raster)
library(ncdf4)

file <- "~/R/hujan/raw/"
shp <- readOGR("basin/ciliwung/ciliwung.shp")
plot(shp)
prec <- nc_open(file)
prec.brick <- brick(file)
extent(prec.brick)
extent(shp)
crs(shp)
crs(prec.brick)
shp <- spTransform(shp, crs(prec.brick))
prec.mask <- mask(prec.brick, shp)
prec.df <- as.data.frame(prec.mask, xy=TRUE)
prec.df <- prec.df[complete.cases(prec.df),]
write.csv(prec.df, file = "coba-coba-hujan.csv")

# ukuran RasterBrick jadi terlalu besar untuk dieksekusi jadi df