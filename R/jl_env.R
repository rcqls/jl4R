## Facility function to 

.jlenv <- function() {
    obj <- new.env()
    class(obj) <- "jlenv"
    obj
}

 `@.jlenv` <- function(obj, key) function(...) {jlcall(key, ...)}

`[.jlenv` <- function(obj, field) {
    field <- as.character(substitute(field))
    jlget(field)
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
    setdiff(R(jl("names(Main)")), c("Base","Core","Main","display_buffer","jl4R_ANSWER","preserved_refs"))
}

`print.jlenv` <- function(obj, ...) {
    cat("julia environment: ", paste( names(obj), collapse=", "),"\n")
}
