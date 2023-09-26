# Julia for R

This is an attempt to embed the julia language in R. Actually, very basic julia types are converted to R objects. This package is also very experimental


## Install

In a terminal (tested on macOS M1 with julia-1.9.2:) with `julia` and `Rscript` binaries supposed to be in the `PATH` environment variable,

```{bash}
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/rcqls/jl4R/HEAD/inst/install.sh)"
```

## Test

Inside the R console:
## Example
```{.R execute="false"}
require(jl4R)
# no need .jlInit() since automatically called once
.jl("a=1")
.jl("2a")
.jl('using RDatasets') # A bit slow, julia and RDatasets initializations
.jl('iris=dataset("datasets","iris")') # yes, it is a bit weird, but it is for testing!
a<-.jl('iris[!,2]')

# a is then an R object
a

# another call
.jl('names(iris)')

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