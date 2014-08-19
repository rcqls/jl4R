# Julia for R

This is an attempt to embed the julia language in R. Actually, very basic julia types are converted to R objects (DataFrame coming soon!).


## Install

In the parent directory,

	R CMD INSTALL jl4R
	
If you're using MacOSX with R version < 3.0.0 (default arch=i386),

	R64 CMD INSTALL --no-multiarch jl4R

since julia is (by default) based on x86_64 architecture. 

## Test

First, in a terminal or in your .bashrc (or equivalent):

	export JULIA_DIR=<your julia directory>

Then, the R console:

```{.R execute="false"}
require(jl4R)			# => true
.jl('LOAD_PATH')	# => [<your julia home>/local/share/julia/site/v0.3", "<your julia home>/share/julia/site/v0.3"]
```

## Example
```{.R execute="false"}
require(jl4R)
# no need .jlInit() since automatically called once
.jl('using RDatasets') # A bit slow, julia and RDatasets initializations
.jl('iris=dataset("datasets","iris")') # yes, it is a bit weird, but it is for testing!
a<-.jl('array(iris[2])')

# a is then an R object
a

# another call
.jl('map(string,names(iris))')

# a plot should work too!
plot(.jl('array(iris[1])')~.jl('array(iris[2])'))
```

## Remark

Maybe, this (or something similar) needs to be added in your .bash_profile for Mac users:

	export DYLD_FALLBACK_LIBRARY_PATH=$JULIA_DIR/lib/julia:/usr/lib