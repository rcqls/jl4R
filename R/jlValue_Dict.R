## TODO: toR.Dict

names.Dict <- function(jlval) jlcallR("collect",jlcall("keys",jlval))

"[.Dict" <- function(jlval, field) {
     if(field %in% names(jlval)) {
        jlcall("getindex",jlval,jl_symbol(field))
    } else NULL
}

"$.Dict" <- function(jlval, field) jlval[field]
