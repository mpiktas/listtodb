
elemtovarchar <- function(x,name) {
    x[[name]] <- rawToChar(serialize(x[[name]],NULL,ascii=TRUE))
    x
}
