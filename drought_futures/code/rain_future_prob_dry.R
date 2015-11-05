
#### name:rain future prob ####
library(reshape)
library(sqldf)

indir  <- "~/projects/GARNAUT_CLIMATE_CHANGE_REVIEW/rain/data_derived"
dir(indir)

# dryer
infile <- "A1FIR1_RainSD07_by_season.csv"
dat <- read.csv(file.path(indir, infile))
str(dat)

# construct a time series for each SD of proportional changes
# first reshape, just NSW sds
names(dat)
sdlist <- names(dat)[grep("X1", names(dat))]
dat2 <- dat[,c("year", "order", "season", sdlist)]
str(dat2)

dat3 <- melt(dat2, c("year","order","season"))
str(dat3)

baseline <- sqldf("select *
from dat3
where variable like 'X1%'
  and year = 1990
")
names(dat3) <- gsub("order", "ord1", names(dat3))
head(dat3)


joind <- sqldf("select t1.year, t1.ord1, t1.season, t1.variable, t1.value/t2.value as proportion
from dat3 t1
left join baseline t2
on t1.season = t2.season and t1.variable = t2.variable
", drv = "SQLite")
head(joind, 20)

# need to aggregate the two far north west sds (160 + 135)
joind$sd_group <- joind$variable
joind$sd_group <- gsub("X135",   "North and Far Western", joind$sd_group) 
joind$sd_group <- gsub("X160",   "North and Far Western", joind$sd_group) 


joind$sd_group <- gsub("X105",          "Sydney", joind$sd_group) 
joind$sd_group <- gsub("X110",          "Hunter", joind$sd_group) 
joind$sd_group <- gsub("X115",       "Illawarra", joind$sd_group) 
joind$sd_group <- gsub("X120",  "Richmond-Tweed", joind$sd_group) 
joind$sd_group <- gsub("X125", "Mid-North Coast", joind$sd_group) 
joind$sd_group <- gsub("X130",        "Northern", joind$sd_group) 
joind$sd_group <- gsub("X140",    "Central West", joind$sd_group) 
joind$sd_group <- gsub("X145",   "South Eastern", joind$sd_group) 
joind$sd_group <- gsub("X150",    "Murrumbidgee", joind$sd_group) 
joind$sd_group <- gsub("X155",          "Murray", joind$sd_group) 

joind <- sqldf("select year, ord1, season, sd_group, avg(proportion) as proportion
from joind
group by  year, ord1, season, sd_group
", drv = "SQLite")
str(joind)
head(joind)
data.frame(table(joind$sd_group))
qc <- subset(joind, sd_group == "North and Far Western")
head(qc)
png("figures_and_tables/qc_dry_props_north_far_west.png")
plot(row.names(qc), qc$proportion, type = "l")
dev.off()

# now need to disaggregate each month of the 3 mo seasons
seasons <- data.frame(season = c("djf", "djf","djf","mam", "mam","mam","jja","jja","jja", "son","son","son"),
                      mm = c(12,1:11)
                      )
seasons
str(joind)
joind_mnthly <- sqldf("select t1.sd_group, t1.year, t2.season, t2.mm, proportion
from joind t1
left join
seasons t2
on t1.season = t2.season
order by sd_group, year, mm",
drv = "SQLite")
str(joind_mnthly)
head(joind_mnthly, 24)

qc <- subset(joind_mnthly, sd_group == "Central West")
png("figures_and_tables/qc_dry_props_central_west.png")
plot(row.names(qc), qc$proportion, type = "l")
dev.off()
dir()
write.csv(joind_mnthly, "data/rain_future_prob_dry.csv", row.names = F)
