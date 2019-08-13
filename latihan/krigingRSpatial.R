# REF: [ini](https://rspatial.org/analysis/4-interpolation.html)

# PLOTTING HUJAN

library("rspatial")
library("sp")
library("rgdal")

# ambil sampel data hujan - data frame
d <- sp_data("precipitation")

# menghitung jumlah hujan dalam satu tahun per stasiun dan menyimpannya di kolom baru bernama prec
d$prec <- rowSums(d[, c(6:17)])

# plot nilai hujan tadi secara berurutan
plot(sort(d$prec), ylab='Hujan tahunan (mm)', las=1, xlab='Stasiun')

# membuat tipe data titik mengandung koordinat dan jenis proyeksi
dsp <- SpatialPoints(d[,4:3], proj4string=CRS("+proj=longlat +datum=NAD83"))

# membuat tipe data titik tadi mengandung nilai z dalam data tabel
dsp <- SpatialPointsDataFrame(dsp, d)

# ambil sampel data batas negara - data polygon sp - shp
CA <- sp_data("counties")

# bikin vektor untuk membagi besaran curah hujan - ada 6 grup - untuk properties plotting
cuts <- c(0,200,300,500,1000,3000)

# set fungsi palet warna untuk interpolasi
blues <- colorRampPalette(c('yellow', 'orange', 'blue', 'dark blue'))

# bikin list berisi peta polygon dan properties-nya
pols <- list("sp.polygons", CA, fill = "lightgray")

# plot peta hujan titik di atas peta
spplot(dsp, 'prec', cuts=cuts, col.regions=blues(5), sp.layout=pols, pch=20, cex=2)

# definisikan crs baru
TA <- CRS("+proj=aea +lat_1=34 +lat_2=40.5 +lat_0=0 +lon_0=-120 +x_0=0 +y_0=-4000000 +datum=NAD83 +units=m +ellps=GRS80 +towgs84=0,0,0")

# mengganti proyeksi dan datum dsp (hujan titik) & CA (peta polygonal) ke crs yang baru
dta <- spTransform(dsp, TA)
cata <- spTransform(CA, TA)


# POLUSI UDARA - PAKAI KRIGING

library("rspatial")
library("sp")        # untuk polygonal - vector
library("rgdal")     # untuk raster - bitmap
library("gstat")     # untuk kriging

# ambil sampel data polusi - data frame
x <- sp_data("airqual")

# pilih yang OZDLYAV
# karena satuan per billion untuk mempermudah baca besaran dikali 1000
x$OZDLYAV <- x$OZDLYAV * 1000

# membuat x jadi data titik sp dengan menambahkan koordinat padanya (diambil dari datanya sendiri)
coordinates(x) <- ~LONGITUDE + LATITUDE

# menambahkan crs-nya, nanti akan di ganti dengan yang baru
proj4string(x) <- CRS('+proj=longlat +datum=NAD83')

# membuat crs baru - highligh untuk variogram: +units=km
TA <- CRS("+proj=aea +lat_1=34 +lat_2=40.5 +lat_0=0 +lon_0=-120 +x_0=0 +y_0=-4000000 +datum=NAD83 +units=km +ellps=GRS80")

# x jadi aq - dengan crs TA
aq <- spTransform(x, TA)

# ambil sampel data negara dari paket - peta plygon sp - shp
cageo <- sp_data('counties.rds')

# transformasikan peta proyektor dan datum ke crs yang sama dengan data polusi
ca <- spTransform(cageo, TA)

# konversi polygon ke raster - bikin template raster layernya
r <- raster(ca)

# coba cek bagian resolusi dan dimensi
r$layer

# set resolusi ke 10 km (ada hubungannya dengan +units=km tadi)
res(r) <- 10

# konversi r ke g - data grid sp
g <- as(r, 'SpatialGrid')

# Bikin VARIOGRAMnya cuy

# bikin objek (berupa list) berisi formula regresi untuk "naturalisasi" atau "netralisasi"
gs <- gstat(formula=OZDLYAV~1, locations=aq)
class(gs)

# hitung sampel variogram, ini nih harus dipelajari fungsi R ini!
# pelajari KOMPONEN GRAFIK: np, dist, gamma
v <- variogram(gs, width=20)
class(v) # data frame sih, tapi...
str(v) # jengjreeeeng
head(v) # dilihat sekilas kayak data frame biasa
nrow(v)
plot(v) # udah jadi

# fitting "cocokin" model 
# pelajari ISTILAH: model: nug, exp, sph; psill; range; kappa
fve <- fit.variogram(v, vgm(85, "Exp", 75, 20))
# psill = 85, range = 75, nugget = 20, model exp = oke ini komponen variogram

str(fve) # data frame khusus variogramModel
fve # lihat hasil parameter modelnya

# plot grafik semivariogram model bareng dengan semivariogram pengamatan
plot(variogramLine(fve, 400), type='l', ylim=c(0,120))
points(v[,2:3], pch=20, col='red')

# fitting pakai grafik lain - spherical model
fvs <- fit.variogram(v, vgm(85, "Sph", 75, 20)) # parameternya sama, cuma ganti model
fvs
plot(variogramLine(fvs, 400), type='l', ylim=c(0,120) ,col='blue', lwd=2)
points(v[,2:3], pch=20, col='red')

# plot bagusnya
plot(v, fve)

# Tadi baru bikin semivariogram nya, sekarang baru INTERPOLASI KRIGING nya
# pakai yang fve (model exponensial)
k <- gstat(formula=OZDLYAV~1, locations=aq, model=fve)

# nilai prediksi
kp <- predict(k, g) # ordinary kriging
spplot(kp)

# variance
# pelajari: apa itu VARIANCE dan PREDICTION
ok <- brick(kp)
ok <- mask(ok, ca)
names(ok) <- c('prediction', 'variance')
plot(ok)

## selanjutnya di tutorial link ada compare with other, bisa dilanjutkan setelah ini
## sekarang mau istirahat dulu sudah malam