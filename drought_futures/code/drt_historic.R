
#### name:drt_historic ####
# got this from pre-processing of suicide paper
ch <- connect2postgres2("ewedb")
drt  <- dbGetQuery(ch,
'select t2.geoid,cast(SDcode07 as numeric) as SD_code,sdname07 as SD_name,year,month,avg(t1.sum) as avsum,avg(t1.count) as avcount,avg(t1.rain) as avrain, avg(t1.rescaledpctile) as avindex,
case when avg(t1.count) >= 5  then avg(t1.count) else 0 end as threshold
from bom_grids.rain_NSW_1890_2008_4 as t1 join (
        select abs_sd.aussd07.gid as
        geoid,abs_sd.aussd07.SDcode07, abs_sd.aussd07.SDname07, bom_grids.grid_NSW.*
        from abs_sd.aussd07, bom_grids.grid_NSW
        where st_intersects(abs_sd.aussd07.geom,bom_grids.grid_NSW.the_geom)
         and cast(abs_sd.aussd07.sdcode07 as numeric) < 200
        order by SDcode07,bom_grids.grid_NSW.gid
) as t2 
on t1.gid=t2.gid
group by t2.geoid,SD_code,SD_name,year,month
order by SD_name, year, month
')
str(drt)
data.frame(table(drt$sd_code))

# I aggregate the two north western
recode_sds <- read.csv(textConnection(
"rownames,sd_code,             tsd,              sd_group
       1 ,    105,          Sydney,                Sydney
       2 ,    110,          Hunter,                Hunter
       3 ,    115,       Illawarra,             Illawarra
       4 ,    120,  Richmond-Tweed,        Richmond-Tweed
       5 ,    125, Mid-North Coast,       Mid-North Coast
       6 ,    130,        Northern,              Northern
       7 ,    135,   North Western, North and Far Western
       8 ,    140,    Central West,          Central West
       9 ,    145,   South Eastern,         South Eastern
      10 ,    150,    Murrumbidgee,          Murrumbidgee
      11 ,    155,          Murray,                Murray
      12 ,    160,        Far West, North and Far Western"),
strip.white = T)
str(recode_sds )

qc <- sqldf(
'SELECT sd_group, year, month, avg(avrain) as avrain, avg(avcount) as avcount 
from drt t1
join recode_sds sds
on t1.sd_code=sds.sd_code
group by sd_group, year, month', drv = "SQLite")

data.frame(table(qc$sd_group))
str(qc)

write.csv(qc, "data/drt_historic.csv", row.names = F)
