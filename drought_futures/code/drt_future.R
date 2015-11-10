
#### name:drt_future ####
setwd(projdir)
rain_future_dry <- read.csv("data/rain_future_prob_dry.csv")
rain_future_wet <- read.csv("data/rain_future_prob_wet.csv")
rain_past <- read.csv("data/drt_historic.csv")
summary(rain_past)
# Dry
str(rain_future_dry)
# add a joiner
rain_future_dry$year_join <- rain_future_dry$year - 100
names(rain_future_dry) <- gsub("year$", "year_future", names(rain_future_dry)) 
str(rain_past)
rain_merge  <- sqldf("select t1.sd_group, year, month, year_future, season, avrain,
  proportion, avrain * proportion as rain_projected
from rain_past t1
join
rain_future_dry t2
on t1.year = t2.year_join and t1.month = t2.mm and t1.sd_group = t2.sd_group
order by t2.sd_group, year, month
", drv = "SQLite")
summary(rain_merge)
head(rain_merge)
tail(rain_merge)

# stack these so it appears to be a continuous record
paste(names(rain_merge), sep = "", collapse = "', '")
past  <- rain_merge[,c('sd_group', 'year', 'month', 'avrain')]
future <- rain_merge[,c('sd_group', 'year_future', 'month', 'rain_projected')]
names(future) <- names(past)
future <- future[future$year > 1999,]

head(past); tail(past)
head(future,12); tail(future)
# TODO there is a discontinuity between the observed avrain at 2000
# and the adjusted rain_projected at 2000 because it started being
# adjusted in 1990.  I cannot think of a quick fix to have a smooth
# transition so will just leave as is.
# get avrain 2000 to 2008 from the observed record
str(rain_past)
present <- rain_past[rain_past$year > 2000 & rain_past$year < 2008,1:4]
head(present); tail(present)
# and extrapolate from 2008
future <- future[future$year > 2007 ,]
head(future)
rain_merge <- rbind(past, present, future)
qc  <- rain_merge[rain_merge$sd_group == 'Central West', ]
qc$date <- as.Date(paste(qc$year, qc$month, 1, sep = "-"))
miny = 1900
maxy = 2100
png("graphs/qc_rain_future_estimated_dry_central_west.png", width = 1200, height = 600)
plot(qc[qc$year > miny & qc$year < maxy,"date"],
     qc[qc$year > miny & qc$year < maxy,"avrain"],
     type = "b", col = 'grey', pch = 16)
lines(lowess(qc[qc$year > miny & qc$year < maxy,"avrain"] ~ qc[qc$year > miny & qc$year < maxy,"date"], f = 0.02))
dev.off()
write.csv(rain_merge, "data/rain_future_estimated_dry.csv", row.names = F)

# Wet
str(rain_future_wet)
# add a joiner
rain_future_wet$year_join <- rain_future_wet$year - 100
names(rain_future_wet) <- gsub("year$", "year_future", names(rain_future_wet)) 
str(rain_past)
rain_merge  <- sqldf("select t1.sd_group, year, month, year_future, season, avrain,
  proportion, avrain * proportion as rain_projected
from rain_past t1
join
rain_future_wet t2
on t1.year = t2.year_join and t1.month = t2.mm and t1.sd_group = t2.sd_group
order by t2.sd_group, year, month
", drv = "SQLite")
summary(rain_merge)
head(rain_merge)
tail(rain_merge)

# stack these so it appears to be a continuous record
paste(names(rain_merge), sep = "", collapse = "', '")
past  <- rain_merge[,c('sd_group', 'year', 'month', 'avrain')]
future <- rain_merge[,c('sd_group', 'year_future', 'month', 'rain_projected')]
names(future) <- names(past)
future <- future[future$year > 1999,]

head(past); tail(past)
head(future,12); tail(future)
# TODO there is a discontinuity between the observed avrain at 2000
# and the adjusted rain_projected at 2000 because it started being
# adjusted in 1990.  I cannot think of a quick fix to have a smooth
# transition so will just leave as is.
# get avrain 2000 to 2008 from the observed record
str(rain_past)
present <- rain_past[rain_past$year > 2000 & rain_past$year < 2008,1:4]
head(present); tail(present)
# and extrapolate from 2008
future <- future[future$year > 2007 ,]
head(future)
rain_merge <- rbind(past, present, future)
qc  <- rain_merge[rain_merge$sd_group == 'Central West', ]
qc$date <- as.Date(paste(qc$year, qc$month, 1, sep = "-"))
miny = 1900
maxy = 2100
png("graphs/qc_rain_future_estimated_wet_central_west.png", width = 1200, height = 600)
plot(qc[qc$year > miny & qc$year < maxy,"date"],
     qc[qc$year > miny & qc$year < maxy,"avrain"],
     type = "b", col = 'grey', pch = 16)
lines(lowess(qc[qc$year > miny & qc$year < maxy,"avrain"] ~ qc[qc$year > miny & qc$year < maxy,"date"], f = 0.02))
dev.off()
write.csv(rain_merge, "data/rain_future_estimated_wet.csv", row.names = F)
