names.NamedTuple <- function(jlval) jl_call("keys",jlval)

"[.NamedTuple" <- function(jlval, field) {
    jl_call("getfield",jlval,jl_symbol(field))
}
"$.NamedTuple" <- function(jlval, field) jlval[field]