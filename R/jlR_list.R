## Convert to Tuple or NamedTuple
as.jlValue.list <-  function(obj, ...) {
    if(!.jlrunning()) .jlinit()
    .namedlist2NamedTuple(obj)
   # .namedlist2Dict(obj)
}

## internal
.namedlist2Dict <- function(obj) {
    jlval <- jlValue_eval("Dict{Symbol, Any}()")
    vars <- list()
    pairs <- list()
    for (nm in names(obj)) {
        vars[[nm]] <- as.jlValue(obj[[nm]])
        pairs[[nm]] <- jlcall("=>", jl_symbol(nm), vars[[nm]])
        jlcall("push!", jlval, pairs[[nm]])
    }
    jlval
}

.namedlist2NamedTuple <- function(obj) {
    jlval <- jlValue_eval("Dict{Symbol, Any}()")
    vars <- list()
    pairs <- list()
    for (nm in names(obj)) {
        vars[[nm]] <- as.jlValue(obj[[nm]])
        pairs[[nm]] <- jlcall("=>", jl_symbol(nm), vars[[nm]])
        jlcall("push!", jlval, pairs[[nm]])
    }
    jlval
}