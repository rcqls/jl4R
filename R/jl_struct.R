is.jlStruct <- function(jlval) {
    jlR_isstructtype(jlcall("typeof",jlval))
}

names.jlStruct <- function(jlval) toR(jl_fieldnames(jlval))

"[.jlStruct" <- function(jlval, field) {
    if(field %in% names(jlval)) {
        jlcall("getfield",jlval,jl_symbol(field))
    } else NULL
}

"$.jlStruct" <- function(jlval, field) jlval[field]