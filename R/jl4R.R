# return External Pointer of julia object 
jl <- function(expr) {
    .jleval2jlValue(.jlsafe(expr))
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


# jlget <- function(var) {
#   if(!.jlrunning()) .jlinit()
#   res <- jl(var)
# 	return(res)
# }

# jlset <- function(var,value) {
#   if(!.jlrunning()) .jlinit()
# 	.External("jl4R_set_global_variable", var, .jlsafe(value) ,PACKAGE="jl4R")
# 	return(invisible())
# }