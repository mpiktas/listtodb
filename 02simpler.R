#!/usr/bin/r

library(stats)
library(RSQLite)

data(trees)

fit <- lm(log(Volume) ~ log(Girth) + log(Height), data=trees)

## test for serialization
all.equal(fit,  unserialize( serialize(fit, NULL, ascii=TRUE) ) )

m <- dbDriver("SQLite")
con <- dbConnect(m, dbname = "/tmp/02simpler.sqlite")  ## adjust path if on Windows and /tmp does not exist
if (!dbExistsTable(con, "foo"))
    dbSendQuery(con, "create table foo (id integer, val varchar)")
txt <-  paste("insert into foo values(1, \"", rawToChar(serialize(fit,NULL,ascii=TRUE)), "\")", sep="")
res <- dbSendQuery(con, txt)
dbClearResult(res)
dbDisconnect(con)


con <- dbConnect(m, dbname = "/tmp/02simpler.sqlite")  ## adjust path if on Windows and /tmp does not exist
data <- dbGetQuery(con, "select * from foo where id==1 limit 1")
dbDisconnect(con)


## new check
all.equal(fit,  unserialize( charToRaw(data[,"val"]) ) )

cat("Done.\n")
