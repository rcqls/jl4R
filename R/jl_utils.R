jlshow <- function(jlval) invisible(jlvalue_call("show",jlval))

jldisplay <- function(jlval) invisible(jlvalue_call("display",jlval))

jlsymbol <- function(field) {
    if(!.jlrunning()) .jlinit()
    res <- .External("jl4R_jl_symbol", field, PACKAGE = "jl4R")
    res
}

jlcolon <- function() jlvalue_eval_unsafe(":")


jlisstructtype <- function(jlval) {
    jlvalue_call("isstructtype", jlval)
}

jlfieldnames <- function(jlval) {
    jlvalue_call("fieldnames", jlvalue_call("typeof", jlval))
}

jlgetfield <- function(jlval, field) {
    jlvalue_call("getfield", jlval, jlsymbol(field))
}

jltypeof <- function(jlval) {
    if(!.jlrunning()) .jlinit()
    # res <- .External("jl4R_typeof2R", jlval, PACKAGE = "jl4R")
    jlvalue_call("typeof", jlval)
}
jlstring <- function(jlval) jlvalue_call("string", jlval)

jlRtypeof <- function(jlval) jlRstring(jltypeof(jlval))
jlRstring <- function(jlval) toR(jlstring(jlval))
jlRisstructtype <- function(jlval) toR(jlisstructtype(jlval))
jlRfieldnames <- function(jlval) toR(jlfieldnames(jlval))
jlRgetfield <- function(jlval, field) toR(jlgetfield(jlval, field))

