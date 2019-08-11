## Data sta hujan format Rda-nya cuma ada dua kolom "tgl" & "prc"
## dir=prc/Raingauge/

library("dplyr")

# load datanya - klik aja

tmp <- tunggilis                         # backup
tmp <- dplyr::filter(tmp,!is.na(prc))    # hapus data yang nilai prc-nya NA


## Pertama, tambah satu kolom yang isinya nama stasiun
## Kemudian, tambah lagi dua kolom dengan nilai koordinat

NamaStasiun <- "Tunggilis"    # define NamaStasiun untuk nama stasiunnya
LONx <- NA #106.7559                  # ganti NA kalau gak ada
LATy <- NA #-6.4053                   # ganti NA kalau gak ada
tmp <- data.frame(NamaStasiun,LONx,LATy,tmp)   # tambahkan kolom baru berisi var sta sebagai kolom
tmp$NamaStasiun <- as.character(tmp$NamaStasiun)
head(tmp)
str(tmp)

## rowbind semua data, hasilnya ada 5 kolom: NamaStasiun, LONx, LATy, [ALT], tgl, prc

tmp <- bind_rows(beres,tmp)
nrow(tmp) - nrow(BERES)
beres <- tmp

## BACKUP
BERES <- beres
remove(tunggilis)
