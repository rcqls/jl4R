jlfunction <- function(jlval, parent_envir = parent.frame(3)) {
    isjlf <- is.jlfunction(jlval)
    if(isjlf$ok) {
        key <- isjlf$name
        attrsR <- list(
            name = key,
            jlvalue = jlval,
            parent_envir = parent_envir ## VERY IMPORTANT (see comment below)
        )
        ## IMPORTANT:
        ## parent_envir is required for the next closure to know parent_envir inside
        jlf <- function(...) {
            jlval <- jltrycall(key, ..., parent_envir = parent_envir)
            jlvalue_or_jlexception(match.call(), jlval)
        }
        body(jlf)[[2]][[3]][[2]] <- key
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
        typR <- jlvalue_callR("typeof",jlval)
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
