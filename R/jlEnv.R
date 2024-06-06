
## Facility function to use julia inside R

.jlEnv <- function() {
    obj <- new.env()
    class(obj) <- "jlEnv"
    obj
}

## get access to globalenv()$jl inside the package 
jlEnv <- function() get("jl", envir = globalenv())

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
    if (class(substitute(key)) != "character") {
        key <- deparse(substitute(key))
    }
    ## check if key is a generic function
    gen = jlvalue_eval(key)
    if(is.jlexception(gen)) {
        function(...) gen
    } else {
        function(...) {
            args <- jl_rexprs2(substitute(list(...)), parent.frame())
            if(any(sapply(args, is.jlexception))) {
                jlexceptions(args)
            } else {
                do.call("jlcall", c(key, lapply(args, jl)))
            }
        }
    }
}


# `@.jlEnv` <- function(obj, key) function(...) {
#     args <- c(key, jl_rexprs(substitute(list(...)), list(...)))
#     do.call("jlcall", args)
# }

`[.jlEnv` <- function(obj, key) {
    if(class(substitute(key)) != "character") {
        key <- deparse(substitute(key))
    }
    #function(...) {jlStruct(key, ...)}
    function(...) {
        args <- c(key, jl_rexprs(substitute(list(...)), list(...)))
        do.call("jlStruct", args)
    }
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
    ## setdiff(R(jlvalue_eval("names(Main)")), c("Base","Core","Main","display_buffer","jl4R_ANSWER","preserved_refs"))
    # No Module returned
    setdiff(R(jlvalue_eval("tmp=names(Main);tmp[.!(convert.(Bool, isa.(eval.(tmp),Module)))]")), c("display_buffer","jl4R_ANSWER","preserved_refs"))
}

`print.jlEnv` <- function(obj, ...) {
    if(length(names(obj)) == 0) {
        cat("julia environment empty!\n")
    } else {
        cat("julia environment: ", paste( names(obj), collapse=", "),"\n")
    }
}
