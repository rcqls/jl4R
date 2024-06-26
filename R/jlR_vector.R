jlvalue.double <- jlvalue.integer <- jlvalue.logical <- jlvalue.character <-function(obj, vector=FALSE, ...) {
    if(!.jlrunning()) .jlinit()
    jlval <- .Call("jl4R_VECSXP_to_jl_array_EXTPTRSXP", obj, PACKAGE = "jl4R")
    if(length(obj) == 1 && !vector) {
        jlval[1]
    } else {
        if(is.null(dim(obj))) {
            jlval
        } else {
            splatreshape <- jlvalue_call("splat", jlvalue_eval("reshape"))
            args <- jlvalue_eval("[]")
            jlvalue_call("push!", args, jlval)
            for(d in dim(obj)) {
                jlvalue_call("push!", args, jl(as.integer(d)))
            }
            jlvalue_func1(splatreshape, args)
        }
    }
}