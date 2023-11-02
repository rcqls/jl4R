is.jlStruct <- function(jlval) {
    toR(jl_isstructtype(jl_call("typeof",jlval)))
}

names.jlStruct <- function(jlval) jl_fieldnames(jlval)

"[.jlStruct" <- function(jlval, field) {
    if(field %in% names(jlval)) {
        jl_call("getfield",jlval,jl_symbol(field))
    } else NULL
}

"$.jlStruct" <- function(jlval, field) jlval[field]