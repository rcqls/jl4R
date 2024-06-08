jlArray <- function(...) {
    obj <- c(...)
    jlvalue(obj)
}

length.Array <- function(jlval) {
    jlvalue_callR("length",jlval)
}

"[.Array" <- function(jlval, i) {
    s <- length(jlval)
    if (i > 0 && i <= s) {
        i <- jlvalue_eval(as.character(i))
        jlvalue_call("getindex", jlval, i)
    } else {
        NULL
    }
}