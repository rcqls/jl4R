as_jlValue.factor <- function(fa, ...) {
    jlusing("CategoricalArrays")
    jlcall("categorical", as_jlValue(as.character(fa)))
}