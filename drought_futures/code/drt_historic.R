
#### name:drt_historic ####
# got this from pre-processing of suicide paper
drt  <- dbGetQuery(ch,
'select t2.geoid,cast(SD_code as numeric),SD_name,year,month,avg(t1.sum) as avsum,avg(t1.count) as avcount,avg(t1.rain) as avrain, avg(t1.rescaledpctile) as avindex,
case when avg(t1.count) >= 5  then avg(t1.count) else 0 end as threshold
from bom_grids.rain_NSW_1890_2008_4 as t1 join (
        select abs_sd.nswsd91.gid as
        geoid,abs_sd.nswsd91.SD_code,abs_sd.nswsd91.SD_name,bom_grids.grid_NSW.*
        from abs_sd.nswsd91, bom_grids.grid_NSW
        where st_intersects(abs_sd.nswsd91.the_geom,bom_grids.grid_NSW.the_geom)
        order by SD_code,bom_grids.grid_NSW.gid
) as t2 
on t1.gid=t2.gid
group by t2.geoid,SD_code,SD_name,year,month
order by SD_name, year, month
')
str(drt)
data.frame(table(drt$sd_code))

# BETTER
# FROM 
# just go ahead this time
recode_sds <- dbGetQuery(ch, "select * from recode_sds")

qc <- sqldf(
'SELECT sd_group, year, month, avg(avrain) as avrain, avg(avcount) as avcount 
from drt t1
join recode_sds sds
on t1.sd_code=sds.sd_code
group by sd_group, year, month', drv = "SQLite")

data.frame(table(qc$sd_group))
str(qc)

write.csv(qc, "data/drt_historic.csv", row.names = F)
