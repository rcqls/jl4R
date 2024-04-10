jlArray <- function(...) {
    obj <- c(...)
    as_jlvalue(obj)
}

length.Array <- function(jlval) {
    jlRcall("length",jlval)
}

"[.Array" <- function(jlval, i) {
    s <- length(jlval)
    if (i > 0 && i <= s) {
        i <- jlvalue_eval(as.character(i))
        jlcall("getindex", jlval, i)
    } else {
        NULL
    }
}