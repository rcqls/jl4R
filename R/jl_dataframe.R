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

toR.DataFrame <- function(jlval) {
    nms <- toR(jlcall("names",jlval))
    res <- list()
    for(nm in nms) {
        res[[nm]] <- jlcallR("getindex",jlval, jl_colon(), jl_symbol(nm))
    }
    attr(res,"row.names") <- as.character(1:length(res[[1]]))
    class(res) <- "data.frame"
    res
}

jl.data.frame <- function(df) {
    jlusing("DataFrames")
    splatdf <- jlcall("splat", jl("DataFrame"))
    args <- jl("[]")
    vars <- list()
    pairs <- list()
    for (nm in names(df)) {
        vars[[nm]] <- jl(df[[nm]])
        pairs[[nm]] <- jlcall("=>", jl_symbol(nm), vars[[nm]])
        jlcall("push!", args, pairs[[nm]])
    }
    jlval <- jl_func1(splatdf, args)
    ## Attempt to clean all unused jlValue external pointers
    ## jl_finalize_jlValues(splatdf, args, pairs, vars)
    jlval
}