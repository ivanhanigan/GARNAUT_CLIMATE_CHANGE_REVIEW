
setwd("report1_high_level/")
library(HutchinsonDroughtIndex)
dat <- read.csv("data/rain_future_estimated_dry.csv", stringsAsFactors = F)

# drop the first year as only half
names(dat)

head(dat)
dat$date <- as.Date(paste(dat$year_future, dat$month, 1, sep = "-"))

sds <- names(table(dat$sd_group))
sds
par(mfrow=c(2,6))
sd_drt_out <- matrix(nrow=0,ncol=14)
for(sd_i in sds){
#  sd_i <- sds[1]
dat2 <- dat[dat$year > 1890 & dat$sd_group == sd_i, c('date','year_future','month','avrain','rain_projected')]
summary(dat2)
plot(dat2$date, dat2$avrain, type = "l", col='grey') 
lines(dat2$date, dat2$rain_projected, col = 'blue')
title(sd_i)
nyear <- length(names(table(dat2$year_future)))
nyear

sd_drt <- drought_index_future(
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
