# return External Pointer of julia object 
jlptr <- function(expr) {
    .jleval2jlPtr(.jlsafe(expr))
}

jlptr_unsafe <- function(expr) {
    .jleval2jlPtr(expr)
}

# apply a call to jlptr
jlptr_call <- function(jlptr, ...) {
    args <- list(...)
    if(!is.character(args[1])) {
        error("No julia method specified!")
    }
    switch(length(args),

    )
}

## internals

.jleval2jlPtr <- function(expr) {
  if(!.jlrunning()) .jlinit()
  res <- .External("jl4R_eval2jlPtr", expr, PACKAGE = "jl4R")
  return(res)
}

.jlPtr_call1 <- function(jlv, meth) {
    if(!.jlrunning()) .jlinit()
    .External("jl4R_jlPtr_call1", jlv, meth, PACKAGE = "jl4R")
}

.jlPtr_call2 <- function(jlv, meth, jlarg) {
    if(!.jlrunning()) .jlinit()
    .External("jl4R_jlPtr_call2", jlv, meth, jlarg, PACKAGE = "jl4R")
}

.jlPtr_call3 <- function(jlv, meth, jlarg, jlarg2) {
    if(!.jlrunning()) .jlinit()
    .External("jl4R_jlPtr_call3", jlv, meth, jlarg, jlarg2, PACKAGE = "jl4R")
}