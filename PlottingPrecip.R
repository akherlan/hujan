library("dplyr")
library("ggplot2")
library("rgdal")
library("broom")

library("rgeos")
library("raster")

## Load Precip.Rda, kemudian filter data menjadi hanya stasiun yang punya koordinat
## Sebut saja StaDgCoord (dibuat jadi factor)

load("~/R/hujan/prc/Raingauge/Precip.Rda")

StaDgCoord <- filter(Precip,!is.na(LATy))
StaDgCoord$NamaStasiun <- as.factor(StaDgCoord$NamaStasiun) # ada 11 factor

## Plot hujan Januari 2009

Sta2009Jan <- StaDgCoord %>%
  filter(tgl<="2009-01-31") %>%
  filter(tgl>="2009-01-01")

ggplot(Sta2009Jan, aes(tgl, prc, colour = NamaStasiun)) + theme_grey(base_size = 15) +
  geom_line() + xlab("Tanggal") + ylab("CH (mm)") +
  scale_colour_manual(values = c("#6e2142", "#943855", "#e16363", "#ffd692", "#ff935c","#dc5353","#a72461","#49beb7","#042f4b","#f7be16","#ad1d45"))

## Oke juga, lanjutkan dengan plot di atas koordinat. Langkahnya:
## 1. Rata-ratakan dulu hujan Januari 2009 berdasarkan stasiun

Rerata2009Jan <- aggregate(Sta2009Jan[,5], list(Sta2009Jan$NamaStasiun), mean)
names(Rerata2009Jan)[1:2] <- c("Stasiun","PrcAvg")


## 2. Bikin tabel berisi nama stasiun, data koordinat, dan hujannya.
## Jadi, masing-masing stasiun punya variabel x = lon, y = lat, dan z = hujan

LatLon <- distinct(LatLon <- Sta2009Jan[,1:3])
BahanPlot <- data.frame(LatLon,Rerata2009Jan[,2])
names(BahanPlot)[4] <- "PrcAvg"

## 3. Plot hujan rata-rata Jan 2009 ke masing-masing koordinat stasiun

ggplot() +
  geom_point(data = BahanPlot, aes(x = LONx, y = LATy, color = factor(NamaStasiun), size = PrcAvg)) +
  labs(title = "Plot Lokasi Stasiun dengan Besaran CH")

## 4. Plot peta dengan cara import shp, lalu dijadikan dataframe

dasJawa <- readOGR("basin/das_jawa/das_jawa.shp") # import peta shp
plot(dasJawa) # lihat peta

# plot lokasi stasiun untuk melihatnya di atas batas DAS
dasJawa_df <- tidy(dasJawa, region = "DAS") # buat dataframe dari polygon
# atau bisa dasJawa_df <- fortify(dasJawa, region = "DAS")
head(dasJawa_df)

# filter cuma Ciliwung (gak ada, coba cari dulu id-nya)
# das_ciliwung_df <- filter(dasJawa_df,dasJawa_df$id=="Ciliwung")

ggplot() +
  geom_path(data = dasJawa_df, aes(x = long, y =lat, group = id)) +
  geom_point(data = BahanPlot, aes(x = LONx, y = LATy, color = "red", size=1)) +
  labs(title = "Plot Lokasi Stasiun dengan Batas DAS") +
  coord_fixed(xlim = c(min(Sta2009Jan$LONx)-0.05, max(Sta2009Jan$LONx)+0.05), ylim = c(min(Sta2009Jan$LATy)-0.05, max(Sta2009Jan$LATy)+0.05))

## Untuk membandingkan, kita butuh interpolasinya
library("tmap")

# 1. Thiessen
library("spatstat")
library("maptools")
library("raster")

# Buat tessellated surface (gagal)
th  <-  as(dirichlet(as.ppp(BahanPlot)), Class = "SpatialPolygons")


# Harus dapat interpolasinya pakai Kriging!


## Ref:
## Belajar subset data: url(https://www.datanovia.com/en/lessons/subset-data-frame-rows-in-r/)
## Belajar plot: url(https://www.earthdatascience.org/courses/earth-analytics/spatial-data-r/make-maps-with-ggplot-in-R/)
##  dan di sini: url(https://ropensci.org/blog/2013/08/18/sciordata/)
## Belajar interpolasi: url(https://mgimond.github.io/Spatial/interpolation-in-r.html)
