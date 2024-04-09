jlsymbol <- function(field) {
    if(!.jlrunning()) .jlinit()
    res <- .External("jl4R_jl_symbol", field, PACKAGE = "jl4R")
    res
}

jlcolon <- function() jl_unsafe(":")

## TODO: jl_methods <- function(meth, ...) {
##  jlEnv()@size(jlEnv()@methods(jl(`names`),jl(`[Array]`)))
## }
## Struct facility

jlisstructtype <- function(jlval) {
    jlcall("isstructtype", jlval)
}

jlfieldnames <- function(jlval) {
    jlcall("fieldnames", jlcall("typeof", jlval))
}

jlgetfield <- function(jlval, field) {
    jlcall("getfield", jlval, jlsymbol(field))
}

jltypeof <- function(jlval) {
    if(!.jlrunning()) .jlinit()
    # res <- .External("jl4R_typeof2R", jlval, PACKAGE = "jl4R")
    jlcall("typeof", jlval)
}
jlstring <- function(jlval) jlcall("string", jlval)

jlRtypeof <- function(jlval) jlRstring(jltypeof(jlval))
jlRstring <- function(jlval) toR(jlstring(jlval))
jlRisstructtype <- function(jlval) toR(jlisstructtype(jlval))
jlRfieldnames <- function(jlval) toR(jlfieldnames(jlval))
jlRgetfield <- function(jlval, field) toR(jlgetfield(jlval, field))

