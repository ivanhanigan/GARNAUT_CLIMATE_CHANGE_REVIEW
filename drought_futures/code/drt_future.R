
#### name:drt_future ####
library(sqldf)
setwd(projdir)
rain_future <- read.csv("data/rain_future_prob_dry.csv")
rain_past <- read.csv("data/drt_historic.csv")
str(rain_future)
# add a joiner
rain_future$year_join <- rain_future$year - 100
names(rain_future) <- gsub("year$", "year_future", names(rain_future)) 
str(rain_past)
rain_merge  <- sqldf("select t1.sd_group, year, month, year_future, season, avrain,
  proportion, avrain * proportion as rain_projected
from rain_past t1
join
rain_future t2
on t1.year = t2.year_join and t1.month = t2.mm and t1.sd_group = t2.sd_group
order by t2.sd_group, year, month
", drv = "SQLite")
summary(rain_merge)
head(rain_merge)
tail(rain_merge)

write.csv(rain_merge, "data/rain_future_estimated_dry.csv", row.names = F)
