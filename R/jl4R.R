## the main julia parsing expression !!!
jl <- function(...) {
  if(!.jlRunning()) .jlInit()
  .External("jl4R_eval", ..., PACKAGE = "jl4R")
}


jlGet <- function(var) {
  if(!.jlRunning()) .jlInit()
	return(jl(var))
}

jlSet <- function(var,value) {
  if(!.jlRunning()) .jlInit()
	.External("jl4R_set_global_variable",var,value ,PACKAGE="jl4R")
	return(invisible())
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
  return(invisible())
}

.jlRunning <- function() {
  .Call("jl4R_running", PACKAGE = "jl4R")
}

.jlGetAns <- function() {
  if(!.jlRunning()) .jlInit()
  .Call("jl4R_get_ans", PACKAGE = "jl4R")
}