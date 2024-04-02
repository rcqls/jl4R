jl.factor <- function(fa) {
    jlusing("CategoricalArrays")
    jlcall("categorical",jl(as.character(fa)))
}