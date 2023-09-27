.jlvalue <- function(expr) {
    if(!.jlrunning()) .jlinit()
    .External("jl4R_jlvalue", expr, PACKAGE = "jl4R")
}

.jlvalue_to_R <- function(jlv) {
    if(!.jlrunning()) .jlinit()
    .External("jl4R_jlvalue_to_SEXP", jlv, PACKAGE = "jl4R")
}

.jlcall1 <- function(jlv, meth) {
    if(!.jlrunning()) .jlinit()
    .External("jl4R_jlcall1", jlv, meth, PACKAGE = "jl4R")
}

.jlcall2 <- function(jlv, meth, jlarg) {
    if(!.jlrunning()) .jlinit()
    .External("jl4R_jlcall2", jlv, meth, jlarg, PACKAGE = "jl4R")
}

.jlcall3 <- function(jlv, meth, jlarg, jlarg2) {
    if(!.jlrunning()) .jlinit()
    .External("jl4R_jlcall3", jlv, meth, jlarg, jlarg2, PACKAGE = "jl4R")
}