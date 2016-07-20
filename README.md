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
.jl('LOAD_PATH')	# => NULL (since output is not a DataType but a Union)
.jl('convert(Array{UTF8String},LOAD_PATH)')
# => (for MacOSX)
# julia_home_dir=/Applications/Julia-0.4.6.app/Contents/Resources/julia/lib
# [1] "/Applications/Julia-0.4.6.app/Contents/Resources/julia/local/share/julia/site/v0.4"
# [2] "/Applications/Julia-0.4.6.app/Contents/Resources/julia/share/julia/site/v0.4"   
```

## Example
```{.R execute="false"}
require(jl4R)
# no need .jlInit() since automatically called once
.jl('using RDatasets') # A bit slow, julia and RDatasets initializations
.jl('iris=dataset("datasets","iris")') # yes, it is a bit weird, but it is for testing!
a<-.jl('convert(Array,iris[2])')

# a is then an R object
a

# another call
.jl('map(string,names(iris))')

# a plot should work too! (even if the example is really stupid)
plot(.jl('convert(Array,iris[1])')~.jl('convert(Array,iris[2])'))
```

## Remark

1. Not checked, but the Makevars maybe need to be adapted for linux (at least for Ubuntu where include and lib are not at the same root).

1. NOT SURE THIS REMARK IS STILL USEFUL! Maybe, this (or something similar) needs to be added in your .bash_profile for Mac users:

	export DYLD_FALLBACK_LIBRARY_PATH=$JULIA_DIR/lib/julia:/usr/lib
