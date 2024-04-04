jlArray <- function(...) {
    obj <- c(...)
}

length.Array <- function(jlval) {
    jlcallR("length",jlval)
}

"[.Array" <- function(jlval,i) {
    s <- length(jlval)
    if(i > 0 && i <= s) {
        i <- jl(as.character(i))
        jlcall("getindex",jlval, i)
    } else NULL
}