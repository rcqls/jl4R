## Facility function to 

.jlenv <- function() {
    obj <- new.env()
    class(obj) <- "jlenv"
    obj
}

.jl_load_jlenv <- function() {
    if(!exists("jl", envir = globalenv())) {
        assign("jl", .jlenv(), envir = globalenv())
    }
}

`[.jlenv` <- function(obj, var) {
    if (class(substitute(var)) != "character") {
        var <- deparse(substitute(var))
    }
    jlget(var)
}

`[<-.jlenv` <- function(obj, var, value) {
    if (class(substitute(var)) != "character") {
        var <- deparse(substitute(var))
    }
    jlset(var, value)
}

`names.jlenv` <- function(obj) {

}
