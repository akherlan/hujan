library(RNetCDF)
library(dplyr)

# impor data dari file netcdf
file <- "~/Desktop/rain/3B-DAY-E.MS.MRG.3IMERG.20140312-S000000-E235959.V05.nc4.nc4"
data <- read.nc(open.nc(file))

# dapatkan nilai hujan dan koordinat
prc <- as.data.frame(data$precipitationCal)
xlon <- as.character(data$lon)
ylat <- as.character(data$lat)

# menamai baris dan kolom
names(prc) <- xlon
row.names(prc) <- ylat
prc

# ubah jadi tiga kolom
library(tidyr)

prc <- mutate(prc, lat=row.names(prc))
prc <- gather(prc, "lon", "prc", 1:5)
prc

# alternatif tiga kolom
prc %>%
  mutate(lat = row.names(.)) %>% 
  tidyr::gather("lon","prc",-lat) %>% 
  head()
