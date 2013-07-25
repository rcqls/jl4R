## the main ruby parsing expression !!!
.jl <- function(...) {
  if(!.jlRunning()) .jlInit()
  .External("jl4R_eval", ..., PACKAGE = "jl4R")
}


.jlInit<-function(imgdir=file.path(Sys.getenv("JLAPI_HOME"),"lib")) {
  .External("jl4R_init",imgdir ,PACKAGE="jl4R")
  return(invisible())
}

.jlRunning <- function() {
  .Call("jl4R_running", PACKAGE = "jl4R")
}
