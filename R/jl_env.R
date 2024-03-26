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

`[.jlenv` <- function(obj, field) {
    field <- as.character(substitute(field))
    jlget(var)
}

`$.jlenv` <- function(obj, field) {
    field <- as.character(substitute(field))
    jlget(field)
}

`[<-.jlenv` <- function(obj, field, value) {
    field <- as.character(substitute(field))
    jlset(field, value)
    obj
}

`$<-.jlenv` <- function(obj, field, value) {
    field <- as.character(substitute(field))
    jlset(field, value)
    obj
}

`names.jlenv` <- function(obj) {

}
