jlexception <- function(code, jlval) {
     exc <- list(
        code = code,
        err = jlval
    )
    class(exc) <- c(toR(jlstring(jltypeof(jlval))) , "jlexception")
    exc
}