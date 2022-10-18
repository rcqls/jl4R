## the main ruby parsing expression !!!
.jl <- function(...) {
  if(!.jlRunning()) .jlInit()
  .External("jl4R_eval", ..., PACKAGE = "jl4R")
}

.julia <- function(...) {
  if(!.jlRunning()) .jlInit()
  .External("jl4R_eval", paste(c("display(",...,")"),collapse=""), PACKAGE = "jl4R")
  cat("\n")
  return(invisible())
}


.jlInit<-function() {
  # .External("jl4R_init",imgdir ,PACKAGE="jl4R")
  .External("jl4R_init",PACKAGE="jl4R")
  .jl("JL4R=Dict{Any,Any}()")
  return(invisible())
}

.jlRunning <- function() {
  .Call("jl4R_running", PACKAGE = "jl4R")
}

.jlObj<-function(var) {
  obj<-.External("jl4R_eval",var, PACKAGE = "jl4R")
  attr(obj,"var")<-var
  obj
}

as.jlRVector <- function(obj) .External("jl4R_as_jlRvector",obj,PACKAGE = "jl4R")

.jlGetAns <- function() {
  .Call("jl4R_get_ans", PACKAGE = "jl4R")
}

.jlGet <- function(var) {
	.External("jl4R_get_global_variable",var,PACKAGE="jl4R")
	return(invisible())
}

.jlSet <- function(var,value) {
	.External("jl4R_set_global_variable",var,value ,PACKAGE="jl4R")
	return(invisible())
}