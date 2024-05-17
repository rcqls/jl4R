## Used to eval `<julia expression>` in jl function
jlvalue_eval <- function(obj, ...) {
    if (!.jlrunning()) .jlinit()
    if (length(obj) == 1 && is.character(obj)) {
        .jleval2jlvalue(.jlsafe(obj))
    } else {
        warning("Bad input for jl function!")
        NULL
    }
}

jlvalue.jlvalue <- function(jlval, ...) jlval

## used to evaluate jl(as.name("<julia expresssion>"))
jlvalue.name <- function(name) jlvalue_eval(deparse(name))

is.jlvalue <- function(obj) inherits(obj,"jlvalue")

print.jlvalue <- function(jlval, ...) {
    if (interactive()) {
        invisible(jlvalue_show_display(jlval))
    } else {
        cat(jlvalue_capture_display(jlval))
    }
}

toR.jlvalue <- function(jlval) {
    res <- .jlvalue2R(jlval)
    if (typeof(res) == "externalptr") {
        res
    } else {
        if (is.list(res) && any(sapply(res,is.jlvalue))) {
            sapply(res, toR)
        } else {
            if (is.list(res)) simplify2array(res) else res
        }
    }
}