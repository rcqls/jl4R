## Internal (TODO: put in another R file that represents internal stuff)

.RNamedList2jlDataFrame <- function(df) {
    jlusing("DataFrames")
    splatdf <- jlcall("splat", jlvalue_eval("DataFrame"))
    args <- jlvalue_eval("[]")
    vars <- list()
    pairs <- list()
    for (nm in names(df)) {
        vars[[nm]] <- jlvalue(df[[nm]])
        pairs[[nm]] <- jlcall("=>", jlsymbol(nm), vars[[nm]])
        jlcall("push!", args, pairs[[nm]])
    }
    jlval <- jlvalue_func1(splatdf, args)
    ## Attempt to clean all unused jlvalue external pointers
    ## jl_finalize_jlvalues(splatdf, args, pairs, vars)
    jlval
}


## internal
.RNamedList2jlDict <- function(obj) {
    jlval <- jlvalue_eval("Dict{Symbol, Any}()")
    vars <- list()
    pairs <- list()
    for (nm in names(obj)) {
        vars[[nm]] <- jlvalue(obj[[nm]])
        pairs[[nm]] <- jlcall("=>", jlsymbol(nm), vars[[nm]])
        jlcall("push!", jlval, pairs[[nm]])
    }
    jlval
}

.RNamedList2jlNamedTuple <- function(obj) {
    vars <- list()
    types <- c()
    for (nm in names(obj)) {
        vars[[nm]] <- jlvalue(obj[[nm]])
        types <- c(types, jlRtypeof(vars[[nm]]))
    }
    jlstruct <- paste0("@NamedTuple{", paste(names(obj), "::", types, collapse=",", sep=""), "}") 
    args <- c(jlstruct, unname(vars))
    ## print(args)
    jlval <- do.call("jlStruct", args)
    jlval
}

.RList2jlTuple <- function(obj) {
    splattuple <- jlcall("splat", jlvalue_eval("tuple"))
    args <- jlvalue_eval("[]")
    vars <- list()
    obj <- unname(obj)
    for (i in seq_along(obj)) {
        vars[[i]] <- jlvalue(obj[[i]])
        jlcall("push!", args, vars[[i]])
    }
    jlval <- jlvalue_func1(splattuple, args)
    jlval
}