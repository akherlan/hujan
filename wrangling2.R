library(dplyr)
library(tidyr)
library(readr)

# Import data dari csv

dir <- "raw/Data Prieta/"
namafiles <- list.files(path = dir, pattern = ".csv")

df <- data.frame(c("Tgl","m","y","prc"))

for (i in namafiles) {
  i <- read_delim(paste0(dir,"/",i), "\t", escape_double = F, trim_ws = T)
  i <- i %>%
    gather(m, prc, 2:13) %>%
    mutate(y = rep(as.numeric(substr(i, nchar(i)-7, nchar(i)-4)), length=372)) %>%
    select(Tgl,m,y,prc)
  bind_rows(df,i)
}


## harus pakai lapply!


### sampai sini batas nya ###

# bikin vector berisis nama file xls

dir <- "~/R/hujan/raw/ground/"
file.list <- list.files(path=dir, recursive=T, pattern='*.xls')


# bikin fungsi untuk manggil daftar worksheet dalam satu file xls 

read.all.sheet <- function(namafiles, tibble = FALSE) {
  sheets <- readxl::excel_sheets(filename)
  x <- lapply(sheets, function(X) readxl::read_excel(namafiles, sheet=X, range = "A12:M43", na = "-"))
  if(!tibble) x <- lapply(x, as.data.frame)
  names(x) <- sheets
  x
}

# panggil list-nya

chi <- read.all.sheet("~/R/hujan/raw/ground/Cibanteng Hilir 4th.xls")
chi05 <- chi[["2005"]]

colnames(chi06) <- c("d",as.character(1:12))

chi06<- gather(chi06,"m","prc",2:13)
chi06 <- mutate(chi06,y=rep("2006",length=372))

bind<-bind_rows(chi02,chi04,chi05,chi06)

h<-select(bind,"prc")
t<-select(bind,"y","m","d")
tunggilis_2002_2006<-bind_cols(t,h)

remove(bind,h,t)
save(tunggilis_2002_2006, file = "tunggilis_2002_2006.Rda")

# data dari csv

tunggilis <- read.csv("tunggilis_2000_2009.csv", header = T)


# data dari .Rda

load("tunggilis_2003_2009.Rda")
tunggilis<-tunggilis_2003_2009
str(tunggilis)


# formating tanggal

tunggilis<-separate(tunggilis_2002_2009,Hari,c("y","m","d"),sep = "-")

tgl<-unite(tunggilis[,1:3],"tgl",sep = "/")
tgl<-as.Date(tgl$tgl,format = "%Y/%m/%d")
tgl<-as.data.frame(tgl)
prc<-select(tunggilis,"prc")
tunggilis_bind<-bind_cols(tgl,prc)
names(tunggilis_bind)<-c("tgl","prc")
tunggilis<-tunggilis_bind
str(tunggilis)
plot(tunggilis$tgl,tunggilis$prc)
save(tunggilis,file="tunggilis.Rda")
