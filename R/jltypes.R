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

is.jlValue <- function(obj) inherits(obj,"jlValue")

print.jlValue <- function(obj, ...) {
    print(toR(obj))
}

print.jlUnprintable <- function(obj, ...) print.default(obj)

toR <- function(jlval) UseMethod("toR")

toR.default <- function(obj) obj

toR.jlValue <- function(jlval) {
    res <- .jlValue2R(jlval)
    if(typeof(res) == "externalptr") {
        ## To avoid infinite recursion for print method
        class(res) <- c("jlUnprintable",class(res))
        res
    } else {
        if(is.list(res) && any(sapply(res,is.jlValue))) {
            # print(2)
            sapply(res, toR)
        } else {
            # print(3)
            if(is.list(res)) simplify2array(res) else res
        }
    }
}

toR.DataFrame <- function(jlval) {
    nms <- toR(jl_call("names",jlval))
    res <- list()
    for(nm in nms) {
        res[[nm]] <- jlR_call("getindex",jlval, jl_colon(), jl_symbol(nm))
    }
    attr(res,"row.names") <- as.character(1:length(res[[1]]))
    class(res) <- "data.frame"
    res
}

toR.CategoricalArray <- function(jlval) {
    pool <- jl_getfield(jlval,"pool")
    res <- jlR_getfield(jlval,"refs")
    attr(res,"levels") <- jlR_call("levels",pool)
    class(res) <- "factor"
    res
}