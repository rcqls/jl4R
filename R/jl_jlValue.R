jl.jlValue <- function(jlval) jlval

is.jlValue <- function(obj) inherits(obj,"jlValue")

print.jlValue <- function(jlval, ...) {
    if(interactive()) {
        invisible(jlValue_show_display(jlval))
    } else {
        cat(jlValue_capture_display(jlval))
    }
}

R <- function(jlval) UseMethod("toR")
toR <- function(jlval) UseMethod("toR")

toR.default <- function(obj) obj

toR.jlValue <- function(jlval) {
    res <- .jlValue2R(jlval)
    if(typeof(res) == "externalptr") {
        res
    } else {
        if(is.list(res) && any(sapply(res,is.jlValue))) {
            sapply(res, toR)
        } else {
            if(is.list(res)) simplify2array(res) else res
        }
    }
}