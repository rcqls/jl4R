## internals
.jlvalue2R <- function(jlval) {
    if(!.jlrunning()) .jlinit()
    res <- .External("jl4R_jlvalue2R", jlval, PACKAGE = "jl4R")
    res
}

.jleval2jlvalue <- function(expr) {
  if(!.jlrunning()) .jlinit()
  jlval <- .External("jl4R_eval2jlvalue", expr, PACKAGE = "jl4R")
  if(is.Struct(jlval)) {
    class(jlval) <- c(class(jlval)[1:(length(class(jlval)) - 1)],
        "Struct", "jlvalue")
  }
  return(jlval)
}

.jlvalue_trycall <- function(meth, jlargs, jlkwargs = jlvalue_eval("[]")) {
    if(!.jlrunning()) .jlinit()
    .External("jl4R_jlvalue_trycall", meth, jlargs, jlkwargs, PACKAGE = "jl4R")
}

.jlvalue_call0 <- function(meth) {
    if(!.jlrunning()) .jlinit()
    .External("jl4R_jlvalue_call0", meth, PACKAGE = "jl4R")
}

.jlvalue_call1 <- function(meth, jlv) {
    if(!.jlrunning()) .jlinit()
    .External("jl4R_jlvalue_call1", meth, jlv, PACKAGE = "jl4R")
}

.jlvalue_func_call1 <- function(jl_meth, jlv) {
    if(!.jlrunning()) .jlinit()
    .External("jl4R_jlvalue_func_call1", jl_meth, jlv, PACKAGE = "jl4R")
}

jlvalue_func1 <- function(jl_meth, jlv) .jlvalue_func_call1(jl_meth, jlv)

.jlvalue_call2 <- function(meth, jlv, jlarg) {
    if(!.jlrunning()) .jlinit()
    .External("jl4R_jlvalue_call2", meth, jlv, jlarg, PACKAGE = "jl4R")
}

.jlvalue_call3 <- function(meth, jlv, jlarg, jlarg2) {
    if(!.jlrunning()) .jlinit()
    .External("jl4R_jlvalue_call3", meth, jlv, jlarg, jlarg2, PACKAGE = "jl4R")
}

.jlvalue_call_ <- function(meth, jlargs, jlnargs) {
    if(!.jlrunning()) .jlinit()
    .Call("jl4R_jlvalue_call", meth, jlargs, jlnargs, PACKAGE = "jl4R")
}

.jlvalue_call <- function(meth, ...) {
    jlargs <- list(...)
    jlnargs <- length(jlargs)
    .jlvalue_call_(meth,jlargs,jlnargs)
}

.jlvalue_func_call <- function(jlfunc, jlargs, jlnargs) {
    if(!.jlrunning()) .jlinit()
    .Call("jl4R_jlvalue_func_call", jlfunc, jlargs, jlnargs, PACKAGE = "jl4R")
}

jlvalue_func <- function(jlfunc, ...) {
    jlargs <- list(...)
    jlnargs <- length(jlargs)
    .jlvalue_func_call(jlfunc,jlargs,jlnargs)
}

jlvalue_finalize <- function(...) {
  extptrs <- unlist(c(...))
  invisible(.Call("jl4R_finalizeExternalPtr", extptrs, PACKAGE="jl4R"))
}


jlvalue_show_display <- function(jlval, ...) {
    .Call("jl4R_show_preserved_ref", jlval, PACKAGE = "jl4R")
    NULL
}

jlvalue_capture_display <- function(jlval, ...) {
    .Call("jl4R_capture_preserved_ref", jlval, PACKAGE = "jl4R")
}


jlvalue_new_struct <- function(datatype, jlargs, jlnargs) {
    if (!.jlrunning()) .jlinit()
    return(.Call("jl4R_jlvalue_new_struct", datatype, jlargs, jlnargs, PACKAGE = "jl4R"))
}


