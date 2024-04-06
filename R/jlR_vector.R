as.jlValue.double <- as.jlValue.integer <- as.jlValue.logical <- as.jlValue.character <-function(obj, vector=FALSE, ...) {
    if(!.jlrunning()) .jlinit()
    jlval <- .Call("jl4R_VECSXP_to_jl_array_EXTPTRSXP", obj, PACKAGE = "jl4R")
    if(length(obj) == 1 && !vector) {
        jlval[1]
    } else {
        jlval
    }
}