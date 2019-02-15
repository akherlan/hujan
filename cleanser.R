library(gdata)
library(dplyr)

# 1. Baca file xls ke data.frame
# 2. Memilih hanya baris-baris dengan kolom berisi tanggal
# 3. Select hanya kolom berisi Tgl dan data selama 12 bulan
# 4. Mengganti nama header kolom agar sesuai
# 5. Konversi dari kelas data factor ke integer

sta_2009 <- read.xls(xls = "Gunung-Mas-7th.xls", sheet = 7, verbose = FALSE, na.strings = c("NA"))
sta_2009 <- sta_2009[sta_2009$Nama.Stasiun %in% c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),]
sta_2009 <- sta_2009[, 1:13]
colnames(sta_2009) <- c("Tgl","Jan","Feb","Mar","Apr","Mei","Jun","Jul","Ags","Sep","Okt","Nov","Des")
sta_2009 <- mutate_at(sta_2009, .vars = -1, .funs = ~as.integer(as.character(.)))

# .vars tinggal diganti dgn nama atau indeks kolom
# kalau mau semua kolom tinggal ganti pakai mutate_all

# Save df ke file

save(sta_2009, file = "gunungMas2009.Rda")
write.csv(sta_2009, file = "gunungMas2009.csv")

# Senin, 12 Nov 2018

# konversi ke class date
tanggal <- as.Date(df08_09$Tgl, format = "%Y-%m-%d")
tanggal <- data.frame(tanggal)

# hapus kolom dengan head Tgl
gabung<-subset(gabung, select=-c(Tgl))

# sorting examples using the mtcars dataset
attach(mtcars)

# sort by mpg
newdata <- mtcars[order(mpg),] 

# sort by mpg and cyl
newdata <- mtcars[order(mpg, cyl),]

#sort by mpg (ascending) and cyl (descending)
newdata <- mtcars[order(mpg, -cyl),] 

detach(mtcars)