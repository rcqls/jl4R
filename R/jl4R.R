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

jlR <- function(expr) toR(jl(expr))
jlR_unsafe <- function(expr) toR(jl_unsafe(expr))
jlR_call <- function(meth , ...) toR(jl_call(meth, ...))

jl2R <- function(expr) .jleval2R(.jlsafe(expr))
jl2R_unsafe <- function(expr) .jleval2R(expr)

jlrun <- function(expr) {
  if(!.jlrunning()) .jlinit()
  invisible(.External("jl4R_run", .jlsafe(expr), PACKAGE = "jl4R"))
}

jlshow <- function(expr) {
  jl(paste(c("display(",expr,")"),collapse="")) 
  cat("\n")
  return(invisible())
}

jlget <- function(var) {
  if(!.jlrunning()) .jlinit()
  res <- jl(var)
	return(res)
}

jlset <- function(var,value) {
  if(!.jlrunning()) .jlinit()
	.External("jl4R_set_global_variable", var, .jlsafe(value) ,PACKAGE="jl4R")
	return(invisible())
}