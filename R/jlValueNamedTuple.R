##TODO: toR

names.NamedTuple <- function(jlval) jlcallR("keys",jlval)

"[.NamedTuple" <- function(jlval, field) {
     if(field %in% names(jlval)) {
        jlcall("getfield",jlval,jl_symbol(field))
    } else NULL
}
"$.NamedTuple" <- function(jlval, field) jlval[field]