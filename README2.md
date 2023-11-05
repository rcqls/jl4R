# Julia for R

This is an attempt to embed the julia language in R. Actually, very basic julia types are converted to R objects. This package is also very experimental


## Install

1. Install Julia (all Operating System)

Install [Julia](https://julialang.org/downloads/). For Windows users don't forget to select `PATH` in the installer.

2. Windows user setup

* Install [RTools](https://cran.r-project.org/bin/windows/Rtools/) and a terminal with bash (for instance, [Git Bash](https://gitforwindows.org/))
* Ajout de Rscript dans le `PATH` (see for example [this page](https://www.hanss.info/sebastian/post/rtools-path/) for adding R path in the `PATH` environment variable)

3. Bash installation (all Operating Systems)

In a terminal (tested on macOS M1 with julia-1.9.2:) with `julia` and `Rscript` binaries supposed to be in the `PATH` environment variable,

```{bash}
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/rcqls/jl4R/HEAD/inst/install.sh)"
```

## Test

Inside the R console:
## Examples

### getting started

```{.R execute="false"}
require(jl4R)
# no need .jlInit() since automatically called once
jl("a=1")
jl("2a")
jl('using RDatasets') # A bit slow, julia and RDatasets initializations
jl('iris=dataset("datasets","iris")') # yes, it is a bit weird, but it is for testing!
a<-jl('iris[!,2]')

# a is then an R object
a

# another call
jl('names(iris)')

# a plot should work too! (even if the example is really stupid)
plot(jl('iris[!,1]')~jl('iris[!,2]'))
```
As a comment the example above can be executed in a multiline mode:
```{.R execute="false"}
jl('
	using RDatasets
	iris=dataset("datasets","iris")
	iris[!,2]
') -> a
a
```

### `jlvector`

Our belief is to exchange result cooked in Julia for performance and retrieve the result inside `R` session with the help of vectors that can be easily shared between `R` and `julia`.

```{.R execute="false"}
require(jl4R)
jla <- jlvector("a")
jla   # julia output
jla[] # R output
jlb <- jlvector("b", c(1,3,2))
jlb 
jlb[]
# set jla
jla[] <- c(1,4,2)
jla
jla[]
jla[2] <- 10
jla
```


TODO: Improving the interface with expression julia instead of variable (if useful)