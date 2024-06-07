
## More internal stuff

.jlinit<-function() {
  # .External("jl4R_init",imgdir ,PACKAGE="jl4R")
  .External("jl4R_init",PACKAGE="jl4R")
  #.jl_load_display_buffer()
  .jl_load_jl4r_module()
  return(invisible())
}

.jlexit<-function() {
  # .External("jl4R_init",imgdir ,PACKAGE="jl4R")
  .External("jl4R_exit",PACKAGE="jl4R")
  return(invisible())
}

.jl_load_jl4r_module <- function() {
  f <- system.file(file.path("julia","JL4R.jl"), package="jl4R")
  if(f != "") {
    cmd <-  paste0('include("',f,'")')
    jlrun(cmd)
  }
}

.jl_load_display_buffer <- function() {
  f <- system.file("display_buffer.jl",package="jl4R")
  if(f != "") {
    cmd <-  paste0('include("',f,'")')
    jlrun(cmd)
  }
}

.jlrunning <- function() {
  .Call("jl4R_running", PACKAGE = "jl4R")
}

## the main julia parsing expression !!!

.jleval2R <- function(expr) {
  if(!.jlrunning()) .jlinit()
  res <- .External("jl4R_eval2R", expr, PACKAGE = "jl4R")
  return(res)
}

.jlans <- function() {
  if(!.jlrunning()) .jlinit()
  .Call("jl4R_get_ans", PACKAGE = "jl4R")
}