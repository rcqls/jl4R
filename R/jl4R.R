## IMPORTANT
## 1) jl(`<multiline julia expression>`) redirect to jlvalue_eval("<multiline julia expression>")
## 2) jl(<R object>) is redirected to as_jlvalue(<RObject>)
jl <- function(obj, ..., name_class = TRUE) {
  if (name_class) {
    return(jl_rexpr(substitute(obj), obj))
  }
  as_jlvalue(obj)
}

jlR <- function(obj, ..., name_class = TRUE) {
  if (name_class) {
    res <- jl_rexpr(substitute(obj))
    if (!is.null(res)) return(toR(res))
  }
  toR(as_jlvalue(obj))
}

jl_unsafe <- function(expr) {
    .jleval2jlvalue(expr)
}

as_jlvalue <- function(obj, ...) UseMethod("as_jlvalue", obj)

as_jlvalue.default <- function(expr, ...) {
  warning(paste0("No as_jlvalue conversion for ", expr, " !"))
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
  jlval <- as_jlvalue(value)
  .External("jl4R_set_global_variable", var, jlval, PACKAGE = "jl4R")
  return(invisible())
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

## Facility function

jlpkg <- function(cmd) {
  if (class(substitute(cmd)) != "character") {
    cmd <- deparse(substitute(cmd))
  }
  print(paste0("import Pkg;Pkg.",cmd))
  jlrun(paste0("import Pkg;Pkg.",cmd))
}

jlusing <- function(...) {
  pkgs <- sapply(substitute(c(...))[-1], function(e) ifelse(is.character(e), e, as.character(e)))
  jlrun(paste0("using ",paste(pkgs,collapse=", ")))
}