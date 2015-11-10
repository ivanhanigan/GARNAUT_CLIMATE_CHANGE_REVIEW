
#### name:get_sd_codes ####
library(rpostgrestools)
ch <- connect2postgres2("gislibrary")
pgListTables(ch, "abs_sd")
sd  <- dbGetQuery(ch, "select sdcode07, sdname07
from abs_sd.aussd07
where sdcode07 < '200'")
sd
##    sdcode07        sdname07
## 1       105          Sydney
## 2       110          Hunter
## 3       115       Illawarra
## 4       120  Richmond-Tweed
## 5       125 Mid-North Coast
## 6       130        Northern
## 7       135   North Western
## 8       140    Central West
## 9       145   South Eastern
## 10      150    Murrumbidgee
## 11      155          Murray
## 12      160        Far West
## >
