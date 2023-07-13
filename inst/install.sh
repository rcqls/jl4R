#/bin/bash

export JULIA_DIR=$(julia -e "print(joinpath(splitpath(Sys.BINDIR)[1:end-1]))")
Rscript -e 'remotes::install_github("rcqls/jl4R",force=TRUE,build=FALSE)'