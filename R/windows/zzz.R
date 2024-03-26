.onLoad <- function(lib, pkg) {
  ## Use local=FALSE to allow easy loading of Tcl extensions
  library.dynam("jl4R", pkg, lib,local=FALSE)
  assignInMyNamespace("JL",.jlenv())
}
