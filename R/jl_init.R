
## More internal stuff

.jlinit<-function() {
  # .External("jl4R_init",imgdir ,PACKAGE="jl4R")
  .External("jl4R_init",PACKAGE="jl4R")
  return(invisible())
}

.jlexit<-function() {
  # .External("jl4R_init",imgdir ,PACKAGE="jl4R")
  .External("jl4R_exit",PACKAGE="jl4R")
  return(invisible())
}

.jlrunning <- function() {
  .Call("jl4R_running", PACKAGE = "jl4R")
}

## the main julia parsing expression !!!

.jleval2R <- function(expr) {
  if(!.jlrunning()) .jlinit()
  res <- .External("jl4R_eval2R", expr, PACKAGE = "jl4R")
  if(inherits(res,"jl_value")) {
    res[[1]] <- expr
    res <- jlvalue(res)
  }
  return(res)
}

.jlans <- function() {
  if(!.jlrunning()) .jlinit()
  .Call("jl4R_get_ans", PACKAGE = "jl4R")
}