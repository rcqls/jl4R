is.jlStruct <- function(jlval) {
    toR(jl_isstructtype(jl_call("typeof",jlval)))
}

names.jlStruct <- function(jlval) jl_fieldnames(jlval)

"[.jlStruct" <- function(jlval, field) {
    jl_call("getfield",jlval,jl_symbol(field))
}

"$.jlStruct" <- function(jlval, field) jlval[field]