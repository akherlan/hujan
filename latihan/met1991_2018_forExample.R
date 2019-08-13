#################   LATIHAN   ##############

library(MASS)
library(dplyr)
library(lubridate)
library(ggplot2)


dat <- readRDS(file = "latihan/met1991_2018.Rds")
summary(dat)

dat.mod <-
dat %>% mutate(missing = as.numeric(is.na(Temp)),
               month = month(Date_EST, label=TRUE,abbr=TRUE),
               year  = year(Date_EST),
               weekday = wday(Date_EST,label=TRUE),
               monthw = ceiling(day(Date_EST) / 7) ) %>% 
  group_by(month,year,weekday,monthw) %>% 
  summarise(percent = mean(missing) * 100) 

dat.mod %>%  
  ggplot() + aes( weekday, monthw,fill = percent) + 
  geom_tile(colour = "white") + 
  facet_grid(year~month) + 
  scale_fill_gradient(low="green", high="red") +
  theme(axis.title=element_blank(),
        axis.text=element_blank(),
        axis.ticks=element_blank(),
        strip.text=element_text(angle=0),
        strip.text.y=element_text(angle=0),
        panel.spacing = unit(0, "lines"))


dat.mod <-
dat %>% mutate(missing = as.numeric(is.na(Temp)),
               month = month(Date_EST, label=TRUE,abbr=TRUE),
               year  = year(Date_EST),
               weekday = wday(Date_EST,label=TRUE),
               monthw = ceiling(day(Date_EST) / 7) ) %>% 
  group_by(month,year,weekday,monthw) %>% 
  summarise(percent = mean(missing) * 100,
            Temp = ifelse(percent > 70, NA, median(Temp, na.rm=TRUE))) 

dat.mod %>% ggplot() + aes( weekday,monthw, fill = Temp) + 
  geom_tile(colour = "white") + 
  facet_grid(year~month) + 
  scale_fill_gradient2(low="blue", mid="yellow", high="red",
                       na.value = "grey70", midpoint = 40) +
  theme(axis.title=element_blank(),
        axis.text=element_blank(),
        axis.ticks=element_blank(),
        strip.text.y=element_text(angle=0),
        panel.spacing = unit(0, "lines"))

