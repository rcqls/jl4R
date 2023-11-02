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
    # cat(paste(class(obj),collapse=","),":\n",sep="")
    # print(toR(obj))
    invisible(jlcallR("display",obj))
}

print.jlUnprintable <- function(obj, ...) print.default(obj)

R <- function(jlval) UseMethod("toR")
toR <- function(jlval) UseMethod("toR")

toR.default <- function(obj) obj

toR.jlValue <- function(jlval) {
    res <- .jlValue2R(jlval)
    if(typeof(res) == "externalptr") {
        ## To avoid infinite recursion for print method
        # class(res) <- c("jlUnprintable",class(res))
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
    nms <- toR(jlcall("names",jlval))
    res <- list()
    for(nm in nms) {
        res[[nm]] <- jlcallR("getindex",jlval, jl_colon(), jl_symbol(nm))
    }
    attr(res,"row.names") <- as.character(1:length(res[[1]]))
    class(res) <- "data.frame"
    res
}

toR.CategoricalArray <- function(jlval) {
    pool <- jl_getfield(jlval,"pool")
    res <- jlR_getfield(jlval,"refs")
    attr(res,"levels") <- jlcallR("levels",pool)
    class(res) <- "factor"
    res
}