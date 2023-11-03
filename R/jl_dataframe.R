names.DataFrame <- function(jlval) jlcallR("names",jlval)

"[.DataFrame" <- function(jlval, i, field) {
    if(missing(field)) {
        field <- i
        i <- jl_colon()
    } else {
        i <- jl(as.character(i))
    }
    if(field %in% names(jlval)) {
        jlcall("getindex",jlval, i, jl_symbol(field))
    } else NULL
}
"$.DataFrame" <- function(jlval, field) jlval[field]

jl.data.frame <- function(df) {
    jlusing("DataFrames")
    DF <- jlcall("splat",jl("DataFrame"))
    jl_args <- jl("[]")
    for( nm in names(df)) {
        jlcall("=>",jl_symbol("a"),jl(c(1,2,3)))
        df[[nm]]
    }
    # jlcall("vcat",jlcall("=>",jl_symbol("a"),jl(c(1,2,3))),jlcall("=>",jl_symbol("b"),jl(c(3,4,1)))) -> jl_args
}