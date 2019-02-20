# Input data dari tabel | x | y | z | porositas |

precip <- read.csv("~/R/work/precip.csv", header=TRUE)
b <- as.matrix(precip)
coordinates(precip) <- ~ lon + lat + alt

# Syntax program R untuk menghitung semivariogram eksperimental:

format <- function(b)
{
  n <- length(b[,1])
  A <- matrix(0,n,n)
  distance <- matrix(0,n,n)
  for(i in 1:n)
  {
    for(j in 1:i){
      distance[i,j] <- (sqrt((b[i,1]-b[j,1])^2+(b[i,2]-b[j,2])^2+(b[i,3]-b[j,3])^2)) #masih problem baris ini
      }
  }
  maxdist <- max(distance)
  class <- 1 + 3.3*log10(n)
  width = ceiling(maxdist/class)
  batasmaxclass = width*(ceiling(class))
  variogram = variogram(p~lon+lat+alt, coordinates = ~lon+lat+alt, cutoff=batasmaxclass, width = width, precip)
  variansi=var(precip$p)
  
  cat("Diperoleh nilai sebagai berikut ini :\n")
  cat("maksimum jarak\t = ",maxdist,"\n")
  cat("class \t\t = ",class,"\n")
  cat("width \t\t = ",width,"\n")
  cat("variansi(sill) = ",variansi,"\n")
  cat("\n")
  cat("nilai semivariogramnya : \n")
  cat("\n")
  print(variogram)
}