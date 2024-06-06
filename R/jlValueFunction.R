jlfunction <- function(jlval) {
    isjlf <- is.jlfunction(jlval)
    if(isjlf$ok) {
        key <- isjlf$name
        attrsR <- list(
            name = key,
            jlvalue = jlval
        )
        jlf <- function(...) {
            args <- jl_rexprs(substitute(list(...)), list(...))
            if(any(sapply(args, is.jlexception))) {
                jlexceptions(args)
            } else {
                do.call("jlcall", c(key, lapply(args, jlvalue)))
            }
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
        return(list(ok = substring(typR,1,1) == "#", name = substring(typR,2)))
    } else {
        return(list(ok = FALSE))
    }
}

jlvalue.jlfunction <- function(jlf) attr(jlf, "jlvalue")

print.jlfunction <- function(jlf) {
    print(jlvalue(jlf))
}
