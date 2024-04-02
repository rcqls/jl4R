jl.double <- jl.integer <- jl.logical <- function(obj, vector=FALSE) {
    if(!.jlrunning()) .jlinit()
    jlval <- .Call("jl4R_VECSXP_to_jl_array_EXTPTRSXP", obj, PACKAGE = "jl4R")
    if(length(obj) == 1 && !vector) {
        jlval[1]
    } else {
        jlval
    }
}

jl.character <- function(obj,vector=FALSE) {
    if(!.jlrunning()) .jlinit()
    if(length(obj) == 1 && !vector) {
        ## Evaluate expression
       .jleval2jlValue(.jlsafe(obj)) 
    } else {
        .Call("jl4R_VECSXP_to_jl_array_EXTPTRSXP", obj, PACKAGE = "jl4R")
    }
}


