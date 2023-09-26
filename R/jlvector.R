jlvector <- function(x,value) {
    obj <- list(var=x)
    if(!missing(value)) {
        jlSet(x,value)
    }
    class(obj) <- "jlvector"
    obj
}

 print.jlvector <- function(obj, ...) {invisible(.julia(obj$var))}


"[<-.jlvector" <- "[[<-.jlvector" <- function(obj, i, value) {
    if(missing(i)) {
        jlSet(obj$var,value)
    } else {
        jl(paste0(obj$var,"[",i,"]=",value))
    }
    obj
}

 "[.jlvector" <-  "[[.jlvector" <- function(obj, i) {
    if(missing(i)) {
        jlGet(obj$var)
    } else {
        jlGet(paste0(obj$var,"[",i,"]"))
    }
}

"as.vector.jlvector" <- function(obj, mode = "any") {
    jlGet(obj$var)
}