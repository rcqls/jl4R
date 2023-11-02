names.NamedTuple <- function(jlval) jl_call("keys",jlval)

"[.NamedTuple" <- function(jlval, field) {
     if(field %in% names(jlval)) {
        jl_call("getfield",jlval,jl_symbol(field))
    } else NULL
}
"$.NamedTuple" <- function(jlval, field) jlval[field]