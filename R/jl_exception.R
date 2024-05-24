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