jlCategoricalArray <- function(fa) {
    as_jlValue.factor(fa)
}

toR.CategoricalArray <- function(jlval) {
    pool <- jlgetfield(jlval, "pool")
    res <- jlRgetfield(jlval, "refs")
    attr(res,"levels") <- jlRcall("levels", pool)
    class(res) <- "factor"
    res
}

levels.CategoricalArray <- function(jlval) {
    jlcall("levels", jlval)
}