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


