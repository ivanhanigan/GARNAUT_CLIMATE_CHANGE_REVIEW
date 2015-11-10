
setwd(projdir)
library(HutchinsonDroughtIndex)
dat <- read.csv("data/rain_future_estimated_dry.csv", stringsAsFactors = F)

# drop the first year as only half
dat  <- dat[dat$year > 1890,]
names(dat)

head(dat)
tail(dat)
qc <- sqldf("select sd_group, year, count(*) from dat
group by sd_group, year
order by count(*) desc", drv = "SQLite")
summary(qc)
# good
dat$date <- as.Date(paste(dat$year, dat$month, 1, sep = "-"))

sds <- names(table(dat$sd_group))
sds

# I saved a subset of this to a test dataset for developing the fucntion with, transfer to
# hutch package

# RUN
sd_drt_out <- matrix(nrow=0,ncol=14)
for(sd_i in sds){
#  sd_i <- sds[1]
dat2 <- dat[dat$sd_group == sd_i,
            c('date','year','month','avrain')]
summary(dat2)
nyear <- length(names(table(dat2$year)))
nyear

sd_drt <- drought_index_stations(
  data=dat2
  ,
  years=nyear
  ,
  droughtThreshold=.375
  )
sd_drt <- data.frame(sd_group = sd_i, sd_drt)
sd_drt_out <- rbind(sd_drt_out, sd_drt)
}

summary(sd_drt_out)
write.csv(sd_drt_out, "data/drought_future_estimated_dry.csv", row.names = F)

qc <- read.csv("data/drought_future_estimated_dry.csv")
sd_i <- "Central West"
str(qc)
qc$date <- as.Date(qc$date)
qc2 <- qc[qc$sd_group == sd_i,]
png("graphs/qc_drought_count_central_west.png", width = 1200, height = 600)
with(qc2,
     plot(date, count, type = "l")
     )
dev.off()

setwd(projdir)
library(HutchinsonDroughtIndex)
dat <- read.csv("data/rain_future_estimated_wet.csv", stringsAsFactors = F)

# drop the first year as only half
dat  <- dat[dat$year > 1890,]
names(dat)

head(dat)
tail(dat)
qc <- sqldf("select sd_group, year, count(*) from dat
group by sd_group, year
order by count(*) desc", drv = "SQLite")
summary(qc)
# good
dat$date <- as.Date(paste(dat$year, dat$month, 1, sep = "-"))

sds <- names(table(dat$sd_group))
sds

# I saved a subset of this to a test dataset for developing the fucntion with, transfer to
# hutch package

# RUN
sd_drt_out <- matrix(nrow=0,ncol=14)
for(sd_i in sds){
#  sd_i <- sds[1]
dat2 <- dat[dat$sd_group == sd_i,
            c('date','year','month','avrain')]
summary(dat2)
nyear <- length(names(table(dat2$year)))
nyear

sd_drt <- drought_index_stations(
  data=dat2
  ,
  years=nyear
  ,
  droughtThreshold=.375
  )
sd_drt <- data.frame(sd_group = sd_i, sd_drt)
sd_drt_out <- rbind(sd_drt_out, sd_drt)
}

summary(sd_drt_out)
write.csv(sd_drt_out, "data/drought_future_estimated_wet.csv", row.names = F)

qc <- read.csv("data/drought_future_estimated_wet.csv")
sd_i <- "Central West"
str(qc)
qc$date <- as.Date(qc$date)
qc2 <- qc[qc$sd_group == sd_i,]
png("graphs/qc_drought_count_central_west_wet.png", width = 1200, height = 600)
with(qc2,
     plot(date, count, type = "l")
     )
dev.off()
