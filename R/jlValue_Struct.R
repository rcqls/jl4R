jlStruct <- function(datatype, ...) {
    if (!is.character(datatype)) {
        stop("No julia DataType specified!")
    }
    jlargs <- lapply(list(...), jl)
    jlnargs <- length(jlargs)
    jlvalue_new_struct(datatype,jlargs,jlnargs)
}

is.Struct <- function(jlval) {
    jlRisstructtype(jltypeof(jlval))
}

names.Struct <- function(jlval) list(type=jlRtypeof(jlval), fields=jlRfieldnames(jltypeof(jlval)))

"[.Struct" <- function(jlval, field) {
    if (field %in% names(jlval)) {
        jlgetfield(jlval,jlsymbol(field))
    } else {
        NULL
    }
}

"$.Struct" <- function(jlval, field) jlval[field]