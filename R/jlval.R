## internals

.jleval2jlValue <- function(expr) {
  if(!.jlrunning()) .jlinit()
  jlval <- .External("jl4R_eval2jlValue", expr, PACKAGE = "jl4R")
  if(is.jlStruct(jlval)) {
    class(jlval) <- c(class(jlval)[1:(length(class(jlval))-1)],"jlStruct","jlValue")
  }
  return(jlval)
}

.jlValue_call0 <- function(meth) {
    if(!.jlrunning()) .jlinit()
    .External("jl4R_jlValue_call0", meth, PACKAGE = "jl4R")
}

.jlValue_call1 <- function(meth, jlv) {
    if(!.jlrunning()) .jlinit()
    .External("jl4R_jlValue_call1", meth, jlv, PACKAGE = "jl4R")
}

.jlValue_func_call1 <- function(jl_meth, jlv) {
    if(!.jlrunning()) .jlinit()
    .External("jl4R_jlValue_func_call1", jl_meth, jlv, PACKAGE = "jl4R")
}

jl_func1 <- function(jl_meth, jlv) .jlValue_func_call1(jl_meth, jlv)

.jlValue_call2 <- function(meth, jlv, jlarg) {
    if(!.jlrunning()) .jlinit()
    .External("jl4R_jlValue_call2", meth, jlv, jlarg, PACKAGE = "jl4R")
}

.jlValue_call3 <- function(meth, jlv, jlarg, jlarg2) {
    if(!.jlrunning()) .jlinit()
    .External("jl4R_jlValue_call3", meth, jlv, jlarg, jlarg2, PACKAGE = "jl4R")
}

.jlValue_call <- function(meth, jlargs, jlnargs) {
    if(!.jlrunning()) .jlinit()
    .Call("jl4R_jlValue_call", meth, jlargs, jlnargs, PACKAGE = "jl4R")
}

jl_call <- function(meth, ...) {
    jlargs <- list(...)
    jlnargs <- length(jlargs)
    .jlValue_call(meth,jlargs,jlnargs)
}

.jlValue_func_call <- function(jlfunc, jlargs, jlnargs) {
    if(!.jlrunning()) .jlinit()
    .Call("jl4R_jlValue_func_call", jlfunc, jlargs, jlnargs, PACKAGE = "jl4R")
}

jl_func <- function(jlfunc, ...) {
    jlargs <- list(...)
    jlnargs <- length(jlargs)
    .jlValue_func_call(jlfunc,jlargs,jlnargs)
}

jl_finalize_jlValues <- function(...) {
  extptrs <- unlist(c(...))
  invisible(.Call("jl4R_finalizeExternalPtr", extptrs, PACKAGE="jl4R"))
}


