is.Struct <- function(jlval) {
    jlR_isstructtype(jlcall("typeof",jlval))
}

names.Struct <- function(jlval) toR(jl_fieldnames(jlval))

"[.Struct" <- function(jlval, field) {
    if(field %in% names(jlval)) {
        jlcall("getfield",jlval,jl_symbol(field))
    } else NULL
}

"$.Struct" <- function(jlval, field) jlval[field]


.jlValue_new_struct <- function(datatype, jlargs, jlnargs) {
    if (!.jlrunning()) .jlinit()
    return(.Call("jl4R_jlValue_new_struct", datatype, jlargs, jlnargs, PACKAGE = "jl4R"))
}

jl_new_struct <- function(datatype, ...) {
    jlargs <- lapply(list(...), jl)
    jlnargs <- length(jlargs)
    .jlValue_new_struct(datatype,jlargs,jlnargs)
}