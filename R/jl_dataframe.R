names.DataFrame <- function(jlval) jlR_call("names",jlval)

"[.DataFrame" <- function(jlval, i, field) {
    if(missing(field)) {
        field <- i
        i <- jl_colon()
    } else {
        i <- jl(as.character(i))
    }
    if(field %in% names(jlval)) {
        jl_call("getindex",jlval, i, jl_symbol(field))
    } else NULL
}
"$.DataFrame" <- function(jlval, field) jlval[field]