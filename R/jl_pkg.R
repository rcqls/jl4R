## Facility function

jlpkg <- function(cmd) {
  if (class(substitute(cmd)) != "character") {
    cmd <- deparse(substitute(cmd))
  }
  cat(paste0("import Pkg; Pkg.",cmd), "\n")
  jlrun(paste0("import Pkg;Pkg.",cmd))
}

jlusing <- function(...) {
  pkgs <- sapply(substitute(c(...))[-1], function(e) ifelse(is.character(e), e, as.character(e)))
  jlrun(paste0("using ",paste(pkgs,collapse=", ")))
}

jlpkgadd <- function(..., url = NULL) {
    if (!is.null(url)) {
        jlrun(paste0("import Pkg;Pkg.add(url=\"", url, "\")"))
    } else {
        pkgs <- sapply(substitute(c(...))[-1], function(e) ifelse(is.character(e), e, as.character(e)))
        for (pkg in pkgs) jlrun(paste0("import Pkg;Pkg.add(\"", pkg, "\")"))
    }
}

jlpkgisinstalled <- function(pkg) {
  if (class(substitute(pkg)) != "character") {
    pkg <- deparse(substitute(pkg))
  }
  jlcode = paste0("using TOML;d = TOML.parsefile(Base.active_project());haskey(d[\"deps\"], \"", pkg,"\")")
  jlvalue_eval(jlcode)
}