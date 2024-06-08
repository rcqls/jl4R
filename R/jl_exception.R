jlvalue_or_jlexception <-  function(code, jlval) { 
    if( toR(jlvalue_call("<:", jltypeof(jlval) , .jlvalue_eval("Exception")))) {
        jlexception(code, jlval)
    } else {
        jlval
    }
 }

jlexception <- function(code, jlval) {
     exc <- list(
        code = code,
        err = jlval
    )
    class(exc) <- c(toR(jlstring(jltypeof(jlval))) , "jlexception")
    exc
}

print.jlexception <- function(obj, ...) {
    cat("Julia Exception:",class(obj)[[1]],"\n")
}

summary.jlexception <- function(obj) {
    cat("Julia Exception:",class(obj)[[1]],"\n")
    cat(toR(jlstring(obj$err)),"\n")
}

is.jlexception <- function(exc) inherits(exc, "jlexception")

jlexceptions <- function(excs) {
    excs <- excs[sapply(excs, is.jlexception)]
    class(excs) <- "jlexceptions"
    excs
}

print.jlexceptions <- function(obj, ...) {
    for(exc in obj) {
        print(exc)
    }
}

summary.jlexceptions <- function(obj) {
    for(exc in obj) {
        summary(exc)
    }
}