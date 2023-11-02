jl_symbol <- function(field) jl(paste0(":",field))
jl_colon <- function() jl_unsafe(":")
## Struct facility

jl_isstructtype <- function(jlval) {
    jlcall("isstructtype", jlval)
}

jl_fieldnames <- function(jlv) {
    jlcall("fieldnames",jlcall("typeof",jlv))
}

jl_getfield <- function(jlval,field) {
    jlcall("getfield", jlval, jl_symbol(field))
}

jlR_isstructtype <- function(jlval) toR(jl_isstructtype(jlval))
jlR_fieldnames <- function(jlval) toR(jl_fieldnames(jlval))
jlR_getfield <- function(jlval,field) toR(jl_getfield(jlval,field))




.jlmethod <- function(meth, value) paste0(meth,"(",value,")")

.jltypeof <- function(value) .jleval(.jlmethod("typeof",value))

# Inside try catch end soft scope `global` is required when updating an existing variable.
# This function (TO IMPROVE) add a global statement except for local variable.
#  .jlglobalsoft("local a=2;b=3")
# => "local a=2;global b=3"
# BUG: .jlsafe("a=DataFrame(a=1,b=3)")
# =>  "try\nglobal a=DataFrame(global a=1global ,b=3)\ncatch e\n showerror(stdout,e)\n end"

.jlglobalsoft <- function(cmd) {
    if(length(grep("local ", cmd) > 0)) {
        gsub("(?:local )( *[a-z,A-Z]+ *)(=)", "local \\1===" ,cmd,perl=TRUE) -> b
        gsub("([a-z,A-Z]+ *)(?:=)([^=])", "global \\1=\\2" ,b,perl=TRUE) -> bb
        gsub("(?:local )( *[a-z,A-Z]+ *)(===)", "local \\1=" ,bb,perl=TRUE) -> bbb
        return(bbb)
    } else {
        return(gsub("([a-z,A-Z]+ *)(?:=)([^=])", "global \\1=\\2" ,cmd,perl=TRUE))
    }
}

## To fix .jlglobalsoft

# .jlsafe <- function(expr) {
#   paste0("try\n", .jlglobalsoft(expr), "\ncatch e\n showerror(stdout,e)\n end")
# }

.jlsafe <- function(expr) {
  paste0("try\n", expr, "\ncatch e\n showerror(stdout,e)\n end")
}