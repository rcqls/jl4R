jl <- function(obj, ...) UseMethod("jl")

jlget <- function(var) {
  if(!.jlrunning()) .jlinit()
  res <- jl(var)
	return(res)
}

jlset <- function(var, value, vector = FALSE) {
  if (!.jlrunning()) .jlinit()
  jlval <- if(is.jlValue(value)) value
           else if(is.character(value)) jl.character(value, vector = vector) 
           else jl(value)
	.External("jl4R_set_global_variable", var, jlval, PACKAGE = "jl4R")
	return(invisible())
}

# return External Pointer of julia object 
jl.default <- function(expr) {
  if(class(substitute(expr)) == "character") {
    .jleval2jlValue(.jlsafe(expr))
  } else {
    .jleval2jlValue(.jlsafe(deparse(substitute(expr))))
  }
}

jl_unsafe <- function(expr) {
    .jleval2jlValue(expr)
}

# apply a method call 
jlcall <- function(meth , ...) {
    args <- list(...)
    if(!is.character(meth)) {
        error("No julia method specified!")
    }
    if(length(args) > 3) {
      jl_call(meth, ...)
    } else {
      switch(length(args) + 1,
          .jlValue_call0(meth),
          .jlValue_call1(meth, ...),
          .jlValue_call2(meth, ...),
          .jlValue_call3(meth, ...),
          "Supposed to be done..."
      )
    }
}

jlR <- function(expr) toR(jl(expr))
jlR_unsafe <- function(expr) toR(jl_unsafe(expr))
jlcallR <- function(meth , ...) toR(jlcall(meth, ...))

jl2R <- function(expr) .jleval2R(.jlsafe(expr))
jl2R_unsafe <- function(expr) .jleval2R(expr)

jlrun <- function(expr) {
  if(!.jlrunning()) .jlinit()
  invisible(.External("jl4R_run", .jlsafe(expr), PACKAGE = "jl4R"))
}

jlshow <- function(jlval) invisible(jlcall("show",jlval))

jldisplay <- function(jlval) invisible(jlcall("display",jlval))

jltypeof <- function(jlval) {
    if(!.jlrunning()) .jlinit()
    res <- .External("jl4R_typeof2R", jlval, PACKAGE = "jl4R")
    res
}

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