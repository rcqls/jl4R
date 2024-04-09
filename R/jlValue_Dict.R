jlDict <-  function(...) {
    obj <- list(...)
    if(!.jlrunning()) .jlinit()
    jlval <- jlValue_eval("Dict{Symbol, Any}()")
    vars <- list()
    pairs <- list()
    for (nm in names(obj)) {
        vars[[nm]] <- jlValue_eval(obj[[nm]])
        pairs[[nm]] <- jlcall("=>", jl_symbol(nm), vars[[nm]])
        jlcall("push!", jlval, pairs[[nm]])
    }
    jlval
}

## TODO: toR.Dict

names.Dict <- function(jlval) jlRcall("collect",jlcall("keys",jlval))

"[.Dict" <- function(jlval, field) {
     if(field %in% names(jlval)) {
        jlcall("getindex",jlval,jl_symbol(field))
    } else NULL
}

"$.Dict" <- function(jlval, field) jlval[field]
