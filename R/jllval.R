# return External Pointer of julia object 
jl <- function(expr) {
    .jleval2jlValue(.jlsafe(expr))
}

jl_unsafe <- function(expr) {
    .jleval2jlValue(expr)
}

# apply a call to jlptr
jl_call <- function(meth , ...) {
    args <- list(...)
    if(!is.character(meth)) {
        error("No julia method specified!")
    }
    switch(length(args),
        .jlValue_call1(meth, ...),
        .jlValue_call2(meth, ...),
        .jlValue_call3(meth, ...),
        "Too much argument"
    )
}

# jl_call <- function(meth , ...) {
#     jl2R(jlval_call(meth, ...))
# }

## internals

.jleval2jlValue <- function(expr) {
  if(!.jlrunning()) .jlinit()
  jlval <- .External("jl4R_eval2jlValue", expr, PACKAGE = "jl4R")
  if(is.jlStruct(jlval)) {
    class(jlval) <- c(class(jlval)[1:(length(class(jlval))-1)],"jlStruct","jlValue")
  }
  return(jlval)
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

## Struct facility

jl_isstructtype <- function(jlval) {
    jl_call("isstructtype", jlval)
}

jl_fieldnames <- function(jlv) {
    jl_call("fieldnames",jl_call("typeof",jlv))
}

jl_getfield <- function(jlv,field) {
    jl_call("getfield", jlv, jlptr(paste0(":",field)))
}

