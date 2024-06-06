jlfunction <- function(jlval) {
    isjlf <- is.jlfunction(jlval)
    if(isjlf$ok) {
        key <- isjlf$name
        attrsR <- list(
            name = key,
            jlvalue = jlval
        )
        jlf <- function(...) {
            args <- c(key, jl_rexprs(substitute(list(...)), list(...)))
            if(any(sapply(args, is.jlexception))) {
                jlexceptions(args[-1])
            } else {
                do.call("jlcall", args)
            }
        }
        attributes(jlf) <- attrsR
        class(jlf) <- c("jlfunction", class(jlval))
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
        return(list(ok = substring(typR,1,1) == "#", name = substring(typR,2)))
    } else {
        return(list(ok = FALSE))
    }
}

jlvalue.jlfunction <- function(jlf) attr(jlf, "jlvalue")

print.jlfunction <- function(jlf) {
    print(jlvalue(jlf))
}
