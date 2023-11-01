jl_typeof <- function(jlval) {
    if(!.jlrunning()) .jlinit()
    res <- .External("jl4R_typeof2R", jlval, PACKAGE = "jl4R")
    res
}

.jlValue2R <- function(jlval) {
    if(!.jlrunning()) .jlinit()
    res <- .External("jl4R_jlValue2R", jlval, PACKAGE = "jl4R")
    res
}

print.jlValue <- function(obj, ...) print(toR(obj))

is.jlValue <- function(obj) inherits(obj,"jlValue")

toR <- function(jlval, ...) UseMethod("toR")

toR.default <- function(obj, ...) obj

toR.jlValue <- function(jlval) {
    res <- .jlValue2R(jlval)
    if(is.jlValue(res)) {
        toR(res)
    } else {
        if(is.list(res) && any(sapply(res,is.jlValue))) {
            sapply(res, toR)
        } else {
            simplify2array(res)
        }
    }
}

toR.DataFrame <- function(jlval) {
    nms <- toR(jl_call("names",jlval))
    res <- list()
    for(nm in nms) {
        res[[nm]] <- toR(jl_call("getindex",jlval, jl_unsafe(":"), jl_symbol(nm)))
    }
    attr(res,"row.names") <- as.character(1:length(res[[1]]))
    class(res) <- "data.frame"
    res
}

toR.CategoricalArray <- function(jlval) {
    res <- integer(0)
    attr(res,"levels") <- character(0)
    class(res) <- "factor"
    res
}