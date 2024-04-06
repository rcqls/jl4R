
## Facility function to use julia inside R

.jlEnv <- function() {
    obj <- new.env()
    class(obj) <- "jlEnv"
    obj
}

# `[.jlEnv` <- function(obj, key) {
#     # OLD version (to remove)
#     # key <- deparse(substitute(key))
#     # if((substr(key,1,1) == substr(key,nchar(key),nchar(key))) && (substr(key,1,1) %in% c("'", '"'))) {
#     #     key <- substr(key,2,nchar(key) - 1)
#     #     function(...) {jlnew(key, ...)}
#     # } else {
#     #     function(...) {jlcall(key, ...)}
#     # }
#     if(class(substitute(key)) == "character") {
#         function(...) {jlnew(key, ...)}
#     } else {
#         key <- deparse(substitute(key))
#         function(...) {jlcall(key, ...)}
#     }
# }

`[[.jlEnv` <- function(obj, key) {
    if(class(substitute(key)) != "character") {
        key <- deparse(substitute(key))
    }
    function(...) {jlcall(key, ...)}
}


 `@.jlEnv` <- function(obj, key) function(...) {
    jlcall(key, ...)
}

`[.jlEnv` <- function(obj, key) {
    if(class(substitute(key)) != "character") {
        key <- deparse(substitute(key))
    }
    function(...) {jlnew(key, ...)}
}

`$.jlEnv` <- function(obj, field) {
    field <- as.character(substitute(field))
    jlget(field)
}

`$<-.jlEnv` <- function(obj, field, value) {
    field <- as.character(substitute(field))
    jlset(field, value)
    obj
}

`names.jlEnv` <- function(obj) {
    setdiff(R(jlValue_eval("names(Main)")), c("Base","Core","Main","display_buffer","jl4R_ANSWER","preserved_refs"))
}

`print.jlEnv` <- function(obj, ...) {
    cat("julia environment: ", paste( names(obj), collapse=", "),"\n")
}
