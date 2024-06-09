## N.B.
## jlvalue_<func> use jlvalue_call
## when jl<func> use jltrycall


jlsymbol <- function(field) {
    if(!.jlrunning()) .jlinit()
    res <- .External("jl4R_jl_symbol", field, PACKAGE = "jl4R")
    res
}

jlcolon <- function() jlvalue_eval_unsafe(":")

jlisstructtype <- function(jlval) {
    jltrycall("isstructtype", jlval)
}
jlvalue_isstructtype <- function(jlval) {
    jlvalue_call("isstructtype", jlval)
}

jltypeof <- function(jlval) {
    jltrycall("typeof", jlval)
}
jlvalue_typeof <- function(jlval) {
    if(!.jlrunning()) .jlinit()
    # res <- .External("jl4R_typeof2R", jlval, PACKAGE = "jl4R")
    jlvalue_call("typeof", jlval)
}

jlfieldnames <- function(jlval) {
    jltrycall("fieldnames", jlvalue_call("typeof", jlval))
}
jlvalue_fieldnames <- function(jlval) {
    jlvalue_call("fieldnames", jlvalue_call("typeof", jlval))
}

jlgetfield <- function(jlval, field) {
    jltrycall("getfield", jlval, jlsymbol(field))
}
jlvalue_getfield <- function(jlval, field) {
    jlvalue_call("getfield", jlval, jlsymbol(field))
}

jlstring <- function(jlval) jltrycall("string", jlval)
jlvalue_string <- function(jlval) jlvalue_call("string", jlval)


jltypeofR <- function(jlval) jlstringR(jltypeof(jlval))
jlstringR <- function(jlval) toR(jlstring(jlval))
jlisstructtypeR <- function(jlval) toR(jlisstructtype(jlval))
jlfieldnamesR <- function(jlval) toR(jlfieldnames(jlval))
jlgetfieldR <- function(jlval, field) toR(jlgetfield(jlval, field))

jlshow <- function(jlval) invisible(jltrycall("show",jlval))
jldisplay <- function(jlval) invisible(jltrycall("display",jlval))