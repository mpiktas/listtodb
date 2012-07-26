rm(list=ls())
source("code/simulate.R")
library(RSQLite)
library(forecast)


set.seed(1313)

id1 <- unique(sapply(1:30,function(i)paste0(sample(toupper(letters),5,replace=TRUE),collapse="")))

id2 <- unique(sapply(1:30,function(i)paste0(sample(letters,5,replace=TRUE),collapse="")))

llen <- 10

objdata <- lapply(rep(200,llen),asim)

objlist <- lapply(objdata,function(x)list(data=x,model=auto.arima(x)))

o1 <- mapply(function(x,id1,id2)c(list(id1=id1,id2=id2),x),objlist,sample(id1,llen,replace=TRUE),sample(id2,llen,replace=TRUE),SIMPLIFY=FALSE)

o2 <- lapply(o1,function(x){
    x$data <- rawToChar(serialize(x$data,NULL,ascii=TRUE))
    x
})

o3 <- lapply(o2,function(x){
    x$model <- rawToChar(serialize(x$model,NULL,ascii=TRUE))
    x
})

todb <- as.data.frame(do.call("rbind",o3))

m <- dbDriver("SQLite")

con <- dbConnect(m, dbname = "smallvarchar.sqlite")

dbWriteTable(con,"modeldata",data.frame(todb))

dbDisconnect(con)
