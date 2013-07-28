# Julia for R

This is an attempt to embed the julia language in R. Actually, very basic julia types are converted to R objects (DataFrame coming soon!).

## requirement

[julia-api4rcqls](https://github.com/rcqls/julia-api4rcqls): since the current project is a work in progress and very experimental, we prefer to use the julia-api4rcqls tools. Furthermore, julia-api4rcqls is used both in [jl4R](https://github.com/rcqls/jl4R) and [jl4rb](https://github.com/rcqls/jl4rb) projects.

## Install

In the parent directory,

	R CMD INSTALL jl4R
	
If you're using MacOSX with R version < 3.0.0 (default arch=i386),

	R64 CMD INSTALL --no-multiarch jl4R

since julia is (by default) based on x86_64 architecture. 

## Test

First, in a terminal or in your .bashrc (or equivalent):

	export JLAPI_HOME=<your julia home>

Then, the R console:

```{.R execute="false"}
require(jl4R)			# => true
.jl('LOAD_PATH')	# => [<your julia home>/local/share/julia/site/v0.2", "<your julia home>/share/julia/site/v0.2"]
```

If the last result is unexpected, see the Troubles section.

## Example
```{.R execute="false"}
require(jl4R)
# no need .jlInit() since automatically called once
.jl('using RDatasets') # A bit slow, julia and RDatasets initializations
a<-.jl('iris=data("datasets","iris")') # yes, it is a bit weird, but it is for testing!
.jl(vector(iris[2]))

# a is then an R object
a

# another call
.jl('colnames(iris)')

# a plot should work too!
plot(.jl('vector(iris[1])')~.jl('vector(iris[2])'))
```

## Troubles

1. This package has been tested only in MacOSX system with R64 (not R, only working for i386) version 2.15.2 and R version 3.0.1 (default is 64bit).
1. For linux user, you should also put jl_bytestring_ptr in julia.expmap.
