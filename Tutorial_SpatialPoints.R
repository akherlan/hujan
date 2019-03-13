# impor data tabular stasiun hujan
stat <- read.csv('sta.csv', header = TRUE)
stat

# ubah data tabular menjadi titik spasial
library(sp)
stap <- SpatialPoints(cbind(stat$lon,stat$lat),proj4string = CRS('+proj=longlat +datum=WGS84'))
showDefault(stap)

# visualisasi posisi stasiun pada koordinatnya
plot(stap, col = 'red', pch=20, cex=1.5, axes = TRUE, las = 1, main = 'Stasiun')

# membuat data hujan secara random
prec <- runif(nrow(stat), min=0, max=100)
df <- data.frame(ID=1:nrow(stat), sta=as.character(stat$sta), precip=prec)
df

# memasukkan data.frame ke dalam vector titik stasiun
stap_df <- SpatialPointsDataFrame(stap, data=df)
showDefault(stap_df)

# visualisasi besaran hujan pada titik lokasi stasiun
plot(stap_df, col = 'blue', pch=20,  cex=1+precip/20, axes = TRUE, las = 1, main = 'Hujan')
text(stap_df, stap_df$sta, pos = 4)
