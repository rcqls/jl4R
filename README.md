# Julia for R

This is an attempt to embed the julia language in R. Actually, very basic julia types are converted to R objects (DataFrame coming soon!).


## Install

Clone this git and in the parent directory:

	R CMD INSTALL jl4R
		
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

1. htableh.inc in src/support directory is missing (copy it in include/julia of your julia directory). *Update*: htableh.inc is now in the package (src/jl4R) until the julia core solve the problem. 
1. For linux user, you should also put jl_bytestring_ptr in julia.expmap.
1. If (like me, on MacOSX) the result of the previous test is wrong, the reason may come from the fact that in the initialization of julia libpcre is required and failed to be loaded properly. Then, set

		LD_LIBRARY_PATH=<your julia home>/lib/julia

If you don't want to set LD_LIBRARY_PATH, alternate solution would be: 

change the base/client.jl file as follows: 

split init_load_path into 2 functions
```{.julia execute="false"}
	function init_load_path()
		vers = "v$(VERSION.major).$(VERSION.minor)"
		
		global const DL_LOAD_PATH = ByteString[
			join([JULIA_HOME,"..","lib","julia"],Base.path_separator)
		]
		
		global const LOAD_PATH = ByteString[
			abspath(JULIA_HOME,"..","local","share","julia","site",vers),
			abspath(JULIA_HOME,"..","share","julia","site",vers)
		]
	end
```
Notice that abspath is not used in the definition of DL_LOAD_PATH (since libpcre is required by abspath which depends of DL_LOAD_PATH needed by dlopen). 
Of course, DL_LOAD_PATH depends on the definition of JULIA_HOME (supposed to be here: "your julia home"/lib) which normally is related to 
the location of sys.ji. In such a case, you can install the R package.

