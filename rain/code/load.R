# Project: opensoftware-restricteddata-casestudy
# Author: Your Name
# Maintainer: Who to complain to <yourfault@somewhere.net>

# This file loads all the libraries and data files needed
# Don't do any cleanup here

### Load any needed libraries
library(RODBC)


### Load in any data files
# get the old work I did in 2008 from my Garnaut mental health archive
# ch <- odbcConnectAccess("G:/Rain/seasonal/qc.mdb")
## dat <- sqlQuery(ch,"SELECT A1FIR1_RainSD07.year, seasons.order, seasons.season, *
## FROM seasons INNER JOIN A1FIR1_RainSD07
## ON seasons.season = A1FIR1_RainSD07.season
## ORDER BY A1FIR1_RainSD07.year, seasons.order")

## head(dat[,"805"])
## dat[1:4,c("year","order","season",names(dat)[grep("05",names(dat))])]

## dir()
## write.csv(dat, "data/A1FIR1_RainSD07_by_season.csv", row.names = F)
dat <- read.csv("data/A1FIR1_RainSD07_by_season.csv")
str(dat)

# R2
## dat2 <- sqlQuery(ch,"SELECT A1FIR2_RainSD07.year, seasons.order, seasons.season, *
## FROM seasons INNER JOIN A1FIR2_RainSD07
## ON seasons.season = A1FIR2_RainSD07.season
## ORDER BY A1FIR2_RainSD07.year, seasons.order")

## head(dat2[,"805"])
## dat2[1:4,c("year","order","season",names(dat2)[grep("05",names(dat2))])]

## dir("data")
## write.csv(dat2, "data/A1FIR2_RainSD07_by_season.csv", row.names = F)
dat2 <- read.csv("data/A1FIR2_RainSD07_by_season.csv")
str(dat2)
