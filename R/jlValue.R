## Used to eval `<julia expression>` in jl function
jlValue_eval <- function(obj, ...) {
    if (!.jlrunning()) .jlinit()
    if (length(obj) == 1 && is.character(obj)) {
        .jleval2jlValue(.jlsafe(obj))
    } else {
        warning("Bad input for jl function!")
        NULL
    }
}

as_jlValue.jlValue <- function(jlval, ...) jlval

is.jlValue <- function(obj) inherits(obj,"jlValue")

print.jlValue <- function(jlval, ...) {
    if (interactive()) {
        invisible(jlValue_show_display(jlval))
    } else {
        cat(jlValue_capture_display(jlval))
    }
}

toR.jlValue <- function(jlval) {
    res <- .jlValue2R(jlval)
    if (typeof(res) == "externalptr") {
        res
    } else {
        if (is.list(res) && any(sapply(res,is.jlValue))) {
            sapply(res, toR)
        } else {
            if (is.list(res)) simplify2array(res) else res
        }
    }
}