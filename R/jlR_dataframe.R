as.jlValue.data.frame <- function(df, ...) {
    .namedlist_to_jlDataFrame(df)
}

## Internal (TODO: put in another R file that represents internal stuff)

.namedlist_to_jlDataFrame <- function(df) {
    jlusing("DataFrames")
    splatdf <- jlcall("splat", jlValue_eval("DataFrame"))
    args <- jlValue_eval("[]")
    vars <- list()
    pairs <- list()
    for (nm in names(df)) {
        vars[[nm]] <- jlValue_eval(df[[nm]])
        pairs[[nm]] <- jlcall("=>", jl_symbol(nm), vars[[nm]])
        jlcall("push!", args, pairs[[nm]])
    }
    jlval <- jlValue_func1(splatdf, args)
    ## Attempt to clean all unused jlValue external pointers
    ## jl_finalize_jlValues(splatdf, args, pairs, vars)
    jlval
}