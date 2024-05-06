as_jlvalue.double <- as_jlvalue.integer <- as_jlvalue.logical <- as_jlvalue.character <-function(obj, vector=FALSE, ...) {
    if(!.jlrunning()) .jlinit()
    jlval <- .Call("jl4R_VECSXP_to_jl_array_EXTPTRSXP", obj, PACKAGE = "jl4R")
    if(length(obj) == 1 && !vector && is.null(dim(obj))) {
        jlval[1]
    } else {
        if(is.null(dim(obj))) {
            jlval
        } else {
            splatreshape <- jlcall("splat", jlvalue_eval("reshape"))
            args <- jlvalue_eval("[]")
            jlcall("push!", args, jlval)
            for(d in dim(obj)) {
                jlcall("push!", args, jl(as.integer(d)))
            }
            jlvalue_func1(splatreshape, args)
        }
    }
}