.jlPtr2R <- function(jlptr) {
    if(!.jlrunning()) .jlinit()
    res <- .External("jl4R_jlPtr2R", jlptr, PACKAGE = "jl4R")
    res
}

is.jlPtr <- function(obj) inherits(obj,"jlPtr")

jl2R <- function(jlptr, ...) UseMethod("jl2R")

jl2R.default <- function(obj, ...) obj

jl2R.jlPtr <- function(jlptr) {
    res <- .jlPtr2R(jlptr)
    if(is.jlPtr(res)) {
        jl2R(res)
    } else {
        if(is.list(res) && any(sapply(res,is.jlPtr))) {
            lapply(res, jl2R)
        } else {
            res
        }
    }
}

jl2R.DataFrame <- function(jlp) {
    nms <- .jlPtr2R(.jlPtr_call1(jlp,"names"))
    res <- list()
    for(nm in nms) {
        res[[nm]] <- .jlPtr2R(.jlPtr_call3(jlp,"getindex",jlptr_unsafe(":"), jlptr(paste0(":",nm))))
    }
    attr(res,"row.names") <- as.character(1:length(res[[1]]))
    class(res) <- "data.frame"
    res
}