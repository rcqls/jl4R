jlvalue <- function(obj, ...) UseMethod("jlvalue", obj)

jlvalue.default <- function(expr, ...) {
  warning(paste0("No jlvalue conversion for ", expr, " !"))
  NULL
}

## Used to eval `<julia expression>` in jl function
jlvalue_eval <- function(obj, ...) {
    if (length(obj) == 1 && is.character(obj)) {
        .jlvalue_eval_addclass(obj)
    } else {
        warning("Bad input for .jlvalue_eval function!")
        NULL
    }
}

jleval <- function(obj, ...) {
    if (length(obj) == 1 && is.character(obj)) {
        jlval <- .jlvalue_eval_addclass(obj)
        jlvalue_or_jlexception(obj, jlval)
    } else {
        warning("Bad input for jlvalue_eval function!")
        NULL
    }
}

jlvalue_eval_unsafe <- function(expr) {
    .jlvalue_eval_addclass(expr)
}

jlvalue_invisible <- function(jlval) {
    if(jlvalue_callR("isnothing", jlval)) {
        invisible(jlval)
    } else {
        jlval
    }
}

jlvalue.jlvalue <- function(jlval, ...) jlval

## used to evaluate jl(as.name("<julia expresssion>"))
jlvalue.name <- function(name) jleval(deparse(name))

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