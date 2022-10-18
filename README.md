# Julia for R

This is an attempt to embed the julia language in R. Actually, very basic julia types are converted to R objects. This package is also very experimental


## Install

Choose one of the two installations below:

1) In a terminal in the parent directory of ,

	JULIA_DIR=$(julia -e "print(joinpath(splitpath(Sys.BINDIR)[1:end-1]))") R CMD INSTALL jl4R

2) Inside an R terminal:

	Sys.setenv("JULIA_DIR"=system("julia -e 'print(joinpath(splitpath(Sys.BINDIR)[1:end-1]))'",intern=TRUE))
	remotes::install_github("rcqls/jl4R",force=TRUE,build=FALSE)

## Test

First, in a terminal or in your .bashrc (or equivalent):

	export JULIA_DIR=<your julia directory>

Then, the R console:

## Example
```{.R execute="false"}
require(jl4R)
# no need .jlInit() since automatically called once
.jl('using RDatasets') # A bit slow, julia and RDatasets initializations
.jl('iris=dataset("datasets","iris")') # yes, it is a bit weird, but it is for testing!
a<-.jl('iris[!,2]')

# a is then an R object
a

# another call
.jl('map(string,names(iris))')

# a plot should work too! (even if the example is really stupid)
plot(.jl('iris[!,1]')~.jl('iris[!,2]'))
```
As a comment the example above can be executed in a multiline mode:
```{.R execute="false"}
.jl('
	using RDatasets
	iris=dataset("datasets","iris")
	iris[!,2]
') -> a
a
```

## Remark

1. Not checked, but the Makevars maybe need to be adapted for linux (at least for Ubuntu where include and lib are not at the same root).

1. NOT SURE THIS REMARK IS STILL USEFUL! Maybe, this (or something similar) needs to be added in your .bash_profile for Mac users:

	export DYLD_FALLBACK_LIBRARY_PATH=$JULIA_DIR/lib/julia:/usr/lib
