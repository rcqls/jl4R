toR.CategoricalArray <- function(jlval) {
    pool <- jl_getfield(jlval,"pool")
    res <- jlR_getfield(jlval,"refs")
    attr(res,"levels") <- jlcallR("levels",pool)
    class(res) <- "factor"
    res
}

levels.CategoricalArray <- function(jlval) {
    jlcall("levels", jlval)
}