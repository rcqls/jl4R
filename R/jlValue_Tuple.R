jlTuple <- function(...) {
    obj <- list(...)
    .RList2jlTuple(obj)
}

toR.Tuple <- function(jlval) {
    obj <- list()
    for (i in seq(1, length(jlval))) {
        obj[[i]] <- toR(jlval[i])
    }
    return(obj)
}

length.Tuple <- function(jlval) jlRcall("length", jlval)

"[.Tuple" <- function(jlval, ind) {
     if (ind %in% seq(1, length(jlval))) {
        jlcall("getindex", jlval, jl(as.integer(ind)))
    } else {
        NULL
    }
}