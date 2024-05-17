jlvalue.factor <- function(fa, ...) {
    jlusing("CategoricalArrays")
    jlcall("categorical", jlvalue(as.character(fa)))
}