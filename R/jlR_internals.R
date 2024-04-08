## Internal (TODO: put in another R file that represents internal stuff)

.RNamedList2jlDataFrame <- function(df) {
    jlusing("DataFrames")
    splatdf <- jlcall("splat", jlValue_eval("DataFrame"))
    args <- jlValue_eval("[]")
    vars <- list()
    pairs <- list()
    for (nm in names(df)) {
        vars[[nm]] <- as_jlValue(df[[nm]])
        pairs[[nm]] <- jlcall("=>", jl_symbol(nm), vars[[nm]])
        jlcall("push!", args, pairs[[nm]])
    }
    jlval <- jlValue_func1(splatdf, args)
    ## Attempt to clean all unused jlValue external pointers
    ## jl_finalize_jlValues(splatdf, args, pairs, vars)
    jlval
}


## internal
.RNamedList2jlDict <- function(obj) {
    jlval <- jlValue_eval("Dict{Symbol, Any}()")
    vars <- list()
    pairs <- list()
    for (nm in names(obj)) {
        vars[[nm]] <- as_jlValue(obj[[nm]])
        pairs[[nm]] <- jlcall("=>", jl_symbol(nm), vars[[nm]])
        jlcall("push!", jlval, pairs[[nm]])
    }
    jlval
}

.RNamedList2jlNamedTuple <- function(obj) {
    vars <- list()
    types <- c()
    for (nm in names(obj)) {
        vars[[nm]] <- as_jlValue(obj[[nm]])
        types <- c(types, R(jlcall("typeof", vars[[nm]])))
    }
    jlstruct <- paste0("@NamedTuple{", paste(names(obj), "::", types, collapse=",", sep=""), "}") 
    args <- c(jlstruct, unname(vars))
    ## print(args)
    jlval <- do.call("jlnew", args)
    jlval
}