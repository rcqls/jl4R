.jlmethod <- function(meth, value) paste0(meth,"(",value,")")

.jltypeof <- function(value) .jleval(.jlmethod("typeof",value))

.jlglobalsoft <- function(cmd) {
    gsub("(?:local )( *[a-z,A-Z]+ *)(=)", "local \\1===" ,cmd,perl=TRUE) -> b
    gsub("([a-z,A-Z]+ *)(?:=)([^=])", "global \\1=\\2" ,b,perl=TRUE) -> bb
    gsub("(?:local )( *[a-z,A-Z]+ *)(===)", "local \\1=" ,bb,perl=TRUE) -> bbb
    bbb
}

.jlsafe <- function(...) {
  paste0("try\n", .jlglobalsoft(...), "\ncatch e\n showerror(stdout,e)\n end")
}