.jlsafe <- function(...) {
  paste0("try\n",..., "\ncatch e\n println(e.msg)\n end")
}
## the main julia parsing expression !!!
.jleval <- function(...) {
  if(!.jlrunning()) .jlinit()
  res <- .External("jl4R_eval", ..., PACKAGE = "jl4R")
  return(res)
}

jl <- function(...) {
  res <- .jleval(...)
  # if(is.null(res)) {
  #   var <- paste0("jl4R_RESULT", sample(1:1000000,1))
  #   .jleval(paste0(var," = jl4R_ANSWER"))
  #   if(.jltypeof(var) == "NamedTuple") {
  #     print(var)
  #     res <- jl(.jlmethod("values",var))
  #     print(.jltypeof(.jlmethod("values",var)))
  #     names(res) <- .jleval(.jlmethod("keys",var))
  #   } else {
  #     return(NULL)
  #   }
  # }
  return(res)
}

jlsafe <- function(...) {
  jl(.jlsafe(...))
}

jlrun <- function(...) {
  if(!.jlrunning()) .jlinit()
  invisible(.External("jl4R_run", ..., PACKAGE = "jl4R"))
}

.jlmethod <- function(meth, value) paste0(meth,"(",value,")")

.jltypeof <- function(value) .jleval(.jlmethod("typeof",value))

jlget <- function(var) {
  if(!.jlrunning()) .jlinit()
  res <- jl(var)
  
	return(res)
}

jlset <- function(var,value) {
  if(!.jlrunning()) .jlinit()
	.External("jl4R_set_global_variable",var,value ,PACKAGE="jl4R")
	return(invisible())
}

.jl <- function(...) {
  if(!.jlrunning()) .jlinit()
  .External("jl4R_eval", paste(c("display(",.jlsafe(...),")"),collapse=""), PACKAGE = "jl4R")
  cat("\n")
  return(invisible())
}


.jlinit<-function() {
  # .External("jl4R_init",imgdir ,PACKAGE="jl4R")
  .External("jl4R_init",PACKAGE="jl4R")
  return(invisible())
}

.jlrunning <- function() {
  .Call("jl4R_running", PACKAGE = "jl4R")
}

.jlans <- function() {
  if(!.jlrunning()) .jlinit()
  .Call("jl4R_get_ans", PACKAGE = "jl4R")
}