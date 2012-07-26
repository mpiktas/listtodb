asim <- function(n) {
    repeat {
        res <- try(arima.sim(model=list(ar=runif(2,-1,1),ma=runif(2,-1,1)),n),silent=TRUE)
        if(class(res)=="ts")break;
    }
    res
}

make_obj <- function(n,id1,id2) {
    data <- asim(n)
    model <- auto.arima(data)
    list(id1=id1,id2=id2,data=data,model=model)
}

