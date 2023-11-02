names.DataFrame <- function(jlval) jl_call("names",jlval)

"[.DataFrame" <- function(jlval, field) {
     if(field %in% names(jlval)) {
        jl_call("getfield",jlval,jl_symbol(field))
    } else NULL
}
"$.DataFrame" <- function(jlval, field) jlval[field]