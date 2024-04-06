jlArray <- function(...) {
    obj <- c(...)
    
}

length.Array <- function(jlval) {
    jlcallR("length",jlval)
}

"[.Array" <- function(jlval,i) {
    s <- length(jlval)
    if(i > 0 && i <= s) {
        i <- jlValue_eval(as.character(i))
        jlcall("getindex",jlval, i)
    } else NULL
}