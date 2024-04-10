as_jlvalue.factor <- function(fa, ...) {
    jlusing("CategoricalArrays")
    jlcall("categorical", as_jlvalue(as.character(fa)))
}