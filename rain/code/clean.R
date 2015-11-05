# Project: opensoftware-restricteddata-casestudy
# Author: Your Name
# Maintainer: Who to complain to <yourfault@somewhere.net>

# All the potentially messy data cleanup

attach(dat)
capsd=c(names(dat)[grep("05",names(dat))])
capsd2=c("Sydney","Melbourne","Brisbane","Adelaide","Perth","Hobart","Darwin","Canberra")

#par(mfrow=c(2,1),mar=c(4,4,3,1))
ymax <- 500
plot(1:(4*50),seq(1,3000,3000/(4*50)),type="n",ylim=c(0,ymax),ylab="Rain (mm)", xlab="season",main="R1 - dry")
#for(i in 1:length(capsd)){
  i <- 1
  capsd
lines(dat[1:(4*50),capsd[i]],col=i)
#}
#legend("topleft",capsd,lty=1,col=1:length(capsd))
dev.off()

# check syd stats
# Site name:  SYDNEY (OBSERVATORY HILL)
# Site number:  066062
# from http://www.bom.gov.au/climate/averages/tables/cw_066062.shtml
# choose 61-90
qc <- data.frame(season = c("1_djf","1_djf", "2_mam", "2_mam", "2_mam", "3_jja",
                   "3_jja", "3_jja", "4_son", "4_son", "4_son", "1_djf"),
        mm = c("j","f","m","a","m","j","j","a","s","o","n", "d"),
        mean_rain = c(130.5,    126.1,  163.5,  132.9,  100.6,  140.0,  56.3,   98.6,   64.6,   88.0,   116.2,  84.8)
        )
qc
#library(plyr)
#ddply(qc, c("season"), summarise, rain = sum(mean_rain))
qc2 <- sqldf::sqldf("select season, sum(mean_rain) as sumrain from qc group by season")
qc3 <-
  cbind(dat2[1:4,c("year","order","season",names(dat2)[grep("105",names(dat2))])],
        qc2)
names(qc3)
plot(qc3[,"105"], qc3$sumrain, xlim = c(0,400), ylim = c(0,400))
abline(0,1)
# bom stats are higher, general agreement
