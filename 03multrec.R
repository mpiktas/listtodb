
## these absolute paths do not work when I start ESS from ~ as is the default
##source("code/serialize.R")

library(RSQLite)

aa <- c(list(list(id1="A",id2="B",data=c(1,2))),list(list(id1="A",id2="C",data=c(1,2))))

## why would we want all this?  you can already serialize aa, or bb, or tb -- it really does not matter
## as R's serialize() function will parse _any_ valid R object
## bb <- lapply(aa,elemtovarchar,name="data")
## tb <- do.call("rbind",bb)

m <- dbDriver("SQLite")
con <- dbConnect(m, dbname = "/tmp/03multrec.sqlite")  ## adjust path if on Windows and /tmp does not exist
if (!dbExistsTable(con, "foo"))
    dbSendQuery(con, "create table foo (id1 text, id2 text, val varchar)")

#txt <- paste("insert into foo values ('",paste0(apply(tb,1,paste0,collapse="','"),collapse="'),('"),"')",sep="")
txt <- paste("insert into foo values('a', 'b', '",
             rawToChar(serialize(aa,NULL,ascii=TRUE)),
             "')", sep="")

res <- dbSendQuery(con, txt)

dbClearResult(res)

dbDisconnect(con)

cat("Done.\n")
