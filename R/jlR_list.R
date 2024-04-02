## Convert to Tuple or NamedTuple
jl.list <-  function(obj) {
    if(!.jlrunning()) .jlinit()
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