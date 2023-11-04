

toR.CategoricalArray <- function(jlval) {
    pool <- jl_getfield(jlval,"pool")
    res <- jlR_getfield(jlval,"refs")
    attr(res,"levels") <- jlcallR("levels",pool)
    class(res) <- "factor"
    res
}

jl.factor <- function(fa) {
    jlusing("CategoricalArrays")
    jlcall("categorical",jl(as.character(fa)))
}