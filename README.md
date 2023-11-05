Julia for R
================
RCqls

# Julia for R

This is an attempt to embed the julia language in R. Actually, very
basic julia types are converted to R objects. This package is also very
experimental

## Install

1.  Install Julia (all Operating System)

Install [Julia](https://julialang.org/downloads/). For Windows users
don’t forget to select `PATH` in the installer.

2.  Windows user setup

- Install [RTools](https://cran.r-project.org/bin/windows/Rtools/) and a
  terminal with bash (for instance, [Git
  Bash](https://gitforwindows.org/))
- Ajout de Rscript dans le `PATH` (see for example [this
  page](https://www.hanss.info/sebastian/post/rtools-path/) for adding R
  path in the `PATH` environment variable)

3.  Bash installation (all Operating Systems)

In a terminal (tested on macOS M1 with julia-1.9.2:) with `julia` and
`Rscript` binaries supposed to be in the `PATH` environment variable,

``` bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/rcqls/jl4R/HEAD/inst/install.sh)"
```

    ## /bin/bash: line 2: julia: command not found
    ## Downloading GitHub repo rcqls/jl4R@HEAD
    ## Installation du package dans ‘/opt/homebrew/lib/R/4.3/site-library’
    ## (car ‘lib’ n'est pas spécifié)
    ## * installing *source* package ‘jl4R’ ...
    ## ** using staged installation
    ## ** libs
    ## using C compiler: ‘Apple clang version 14.0.3 (clang-1403.0.22.14.1)’
    ## using SDK: ‘MacOSX13.3.sdk’
    ## clang -I"/opt/homebrew/Cellar/r/4.3.1/lib/R/include" -DNDEBUG   -I/opt/homebrew/opt/gettext/include -I/opt/homebrew/opt/readline/include -I/opt/homebrew/opt/xz/include -I/opt/homebrew/include   -I/include/julia -I.  -fPIC  -g -O2  -c jl4R.c -o jl4R.o
    ## jl4R.c:6:10: fatal error: 'julia.h' file not found
    ## #include "julia.h"
    ##          ^~~~~~~~~
    ## 1 error generated.
    ## make: *** [jl4R.o] Error 1
    ## ERROR: compilation failed for package ‘jl4R’
    ## * removing ‘/opt/homebrew/lib/R/4.3/site-library/jl4R’
    ## * restoring previous ‘/opt/homebrew/lib/R/4.3/site-library/jl4R’
    ## Message d'avis :
    ## Dans i.p(...) :
    ##   l'installation du package ‘/var/folders/56/9j6x05c56936_gmzgd5mygjr0000gn/T//Rtmp4suNK3/remotesd9cd27a16b04/rcqls-jl4R-e863d8c’ a eu un statut de sortie non nul

## Test

Inside the R console: \## Examples

### getting started

### Goal: conversion of `julia` structures used in statitictic to `R`

- `DataFrame`

``` r
require(jl4R)
```

    ## Le chargement a nécessité le package : jl4R

``` r
jlusing(DataFrames)
jl(1)
```

    ## 1.0

``` r
interactive()
```

    ## [1] FALSE

``` r
jl("(a=1,b=DataFrame(a=1:3,b=2:4))") -> nt_jl
nt_jl
```

    ## (a = 1, b = 3×2 DataFrame
    ##  Row │ a      b
    ##      │ Int64  Int64
    ## ─────┼──────────────
    ##    1 │     1      2
    ##    2 │     2      3
    ##    3 │     3      4)

``` r
toR(nt_jl)
```

    ## $a
    ## [1] 1
    ## 
    ## $b
    ##   a b
    ## 1 1 2
    ## 2 2 3
    ## 3 3 4

``` r
R(nt_jl)
```

    ## $a
    ## [1] 1
    ## 
    ## $b
    ##   a b
    ## 1 1 2
    ## 2 2 3
    ## 3 3 4

``` r
jl_typeof(nt_jl)
```

    ## [1] "NamedTuple"

``` r
typeof(nt_jl)
```

    ## [1] "externalptr"

- `CategoricalArray`

``` r
jlusing(CategoricalArrays)
ca_jl <- jl('categorical(["titi","toto","titi"])')
ca_jl
```

    ## 3-element CategoricalArray{String,1,UInt32}:
    ##  "titi"
    ##  "toto"
    ##  "titi"

``` r
R(ca_jl)
```

    ## [1] titi toto titi
    ## Levels: titi toto
