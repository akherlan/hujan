library("RNetCDF")
library("dplyr")
library("tidyr")

daftar <- list.files(path = "~/Desktop/rain", pattern = "nc4", full.names = TRUE)
list_prc <- vector("list", length(daftar))
names(list_prc) <- daftar
for(i in daftar){
  data <- read.nc(open.nc(i))
  prc <- as.data.frame(data$precipitationCal)
  names(prc) <- as.character(data$lon)
  row.names(prc) <- as.character(data$lat)
  prc <- mutate(prc, lat=row.names(prc))
  prc <- gather(prc, "lon", "prc", 1:5)
  list_prc[[i]] <- prc
}

prc_all <- bind_rows(list_prc)
write.csv(prc_all, file = "prc.csv", row.names = FALSE)