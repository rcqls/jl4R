## IMPORTANT
## 1) jl(`<multiline julia expression>`) redirect to jlvalue_eval("<multiline julia expression>")
## 2) jl(<R object>) is redirected to jlvalue(<RObject>)
jl <- function(obj, ..., name_class = TRUE) {
  if (name_class && !(deparse(substitute(obj)) %in% ls(parent.frame()))) {
    return(jl_rexpr(substitute(obj), obj, ...))
  }
  jlvalue(obj, ...)
}

jlR <- function(obj, ..., name_class = TRUE) {
  if (name_class && !(deparse(substitute(obj)) %in% ls(parent.frame()))) {
    res <- jl_rexpr(substitute(obj), ...)
    if (!is.null(res)) return(toR(res))
  }
  toR(jlvalue(obj, ...))
}

jl_unsafe <- function(expr) {
    .jleval2jlvalue(expr)
}

jlvalue <- function(obj, ...) UseMethod("jlvalue", obj)

jlvalue.default <- function(expr, ...) {
  warning(paste0("No jlvalue conversion for ", expr, " !"))
  NULL
}

R <- function(jlval) UseMethod("toR")
toR <- function(jlval) UseMethod("toR")

toR.default <- function(obj) obj

jlget <- function(var) {
  if (!.jlrunning()) .jlinit()
  res <- jlvalue_eval(var)
  return(res)
}

jlset <- function(var, value, vector = FALSE) {
  if (!.jlrunning()) .jlinit()
  jlval <- jlvalue(value)
  .External("jl4R_set_global_variable", var, jlval, PACKAGE = "jl4R")
  return(invisible())
}

# jltrycall safe version of jlcall

jltrycall <- function(meth, ...) {
  args <- jl_rexprs2(substitute(list(...)), parent.frame())
  ## print(args)
  nmargs <- names(args)
  if(is.null(nmargs)) nmargs <- rep("",length(args))
  kwargs <- args[nmargs != ""]
  args <- args[nmargs == ""]
  ## print(list(args=args, kwargs=kwargs))
  ## print(lapply(args, jl))
  ## print(.RNamedList2jlNamedTuple(kwargs))
  .jlvalue_trycall(jlvalue(meth), jl(lapply(args, jl)), .RNamedList2jlNamedTuple(kwargs))
}

# apply a method call 
jlcall <- function(meth , ...) {
    args <- list(...)
    if (!is.character(meth)) {
        error("No julia method specified!")
    }
    if (length(args) > 3) {
      jlvalue_call(meth, ...)
    } else {
      switch(length(args) + 1,
          .jlvalue_call0(meth),
          .jlvalue_call1(meth, ...),
          .jlvalue_call2(meth, ...),
          .jlvalue_call3(meth, ...),
          "Supposed to be done..."
      )
    }
}

jlR_unsafe <- function(expr) toR(jl_unsafe(expr))
jlRcall <- function(meth , ...) toR(jlcall(meth, ...))

jl2R <- function(expr) .jleval2R(.jlsafe(expr))
jl2R_unsafe <- function(expr) .jleval2R(expr)

jlrun <- function(expr) {
  if(!.jlrunning()) .jlinit()
  invisible(.External("jl4R_run", .jlsafe(expr), PACKAGE = "jl4R"))
}

jlshow <- function(jlval) invisible(jlcall("show",jlval))

jldisplay <- function(jlval) invisible(jlcall("display",jlval))