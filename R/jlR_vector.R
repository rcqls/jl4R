as_jlValue.double <- as_jlValue.integer <- as_jlValue.logical <- as_jlValue.character <-function(obj, vector=FALSE, ...) {
    if(!.jlrunning()) .jlinit()
    jlval <- .Call("jl4R_VECSXP_to_jl_array_EXTPTRSXP", obj, PACKAGE = "jl4R")
    if(length(obj) == 1 && !vector) {
        jlval[1]
    } else {
        if(is.null(dim(obj))) {
            jlval
        } else {
            splatreshape <- jlcall("splat", jlValue_eval("reshape"))
            args <- jlValue_eval("[]")
            jlcall("push!", args, jlval)
            for(d in dim(obj)) {
                jlcall("push!", args, jl(as.integer(d)))
            }
            jlValue_func1(splatreshape, args)
        }
    }
}