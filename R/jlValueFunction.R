jlfunction <- function(jlval) {
    isjlf <- is.jlfunction(jlval)
    if(isjlf$ok) {
        key <- isjlf$name
        attrsR <- list(
            name = key,
            jlvalue = jlval
        )
        jlf <- function(...) {
            jlval <- jltrycall(key, ...)
            jlvalue_or_jlexception(match.call(), jlval)
        }
        attributes(jlf) <- attrsR
        class(jlf) <- "jlfunction"
        jlf
    } else {
        function(...) {
            warning("Not a julia function!")
            jlval
        }
    }
}

is.jlfunction <- function(jlval) {
    if(is.jlvalue(jlval)) {
        typR <- R(jltypeof(jlval))
        if(substring(typR,1,1) == "#") {
            return(list(ok = TRUE, name = substring(typR,2)))
        } else {
            return(list(ok = FALSE, name = typR))
        }
    } else {
        return(list(ok = FALSE))
    }
}

jlvalue.jlfunction <- function(jlf) attr(jlf, "jlvalue")

print.jlfunction <- function(jlf) {
    print(jlvalue(jlf))
}
