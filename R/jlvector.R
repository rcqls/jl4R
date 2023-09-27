jlvector <- function(x,value) {
    obj <- list(var=x)
    if(!missing(value)) {
        jlset(x,value)
    }
    class(obj) <- "jlvector"
    obj
}

 print.jlvector <- function(obj, ...) {invisible(.jl(obj$var))}


"[<-.jlvector" <- "[[<-.jlvector" <- function(obj, i, value) {
    if(missing(i)) {
        jlset(obj$var,value)
    } else {
        jl(paste0(obj$var,"[",i,"]=",value))
    }
    obj
}

 "[.jlvector" <-  "[[.jlvector" <- function(obj, i) {
    if(missing(i)) {
        jlget(obj$var)
    } else {
        jlget(paste0(obj$var,"[",i,"]"))
    }
}

"as.vector.jlvector" <- function(obj, mode = "any") {
    jlget(obj$var)
}