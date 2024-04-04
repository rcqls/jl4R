## Convert to Tuple or NamedTuple
jl.list <-  function(obj) {
    if(!.jlrunning()) .jlinit()
    .namedlist_To_Named(obj)
}

## internal
.namedlist_To_Dict <- function(obj) {
    jlval <- jl("Dict{Symbol, Any}()")
    vars <- list()
    pairs <- list()
    for (nm in names(obj)) {
        vars[[nm]] <- jl(obj[[nm]])
        pairs[[nm]] <- jlcall("=>", jl_symbol(nm), vars[[nm]])
        jlcall("push!", jlval, pairs[[nm]])
    }
    jlval
}

.namedlist_To_NamedTuple <- function(obj) {
    jlval <- jl("Dict{Symbol, Any}()")
    vars <- list()
    pairs <- list()
    for (nm in names(obj)) {
        vars[[nm]] <- jl(obj[[nm]])
        pairs[[nm]] <- jlcall("=>", jl_symbol(nm), vars[[nm]])
        jlcall("push!", jlval, pairs[[nm]])
    }
    jlval
}