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

## Test

Inside the R console: \## Examples

### getting started

``` r
require(jl4R)
```

    ## Le chargement a nécessité le package : jl4R

``` r
jl(1)
```

    ## 1.0

``` r
v_jl <- jl(c(1,3,2))
v_jl
```

    ## 3-element Vector{Float64}:
    ##  1.0
    ##  3.0
    ##  2.0

``` r
R(v_jl)
```

    ## [1] 1 3 2

### Goal: conversion of `julia` structures used in statitictic to `R`

- `DataFrame`

``` r
require(jl4R)
jlusing(DataFrames)
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
require(jl4R)
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
