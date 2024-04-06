as.jlValue.factor <- function(fa, ...) {
    jlusing("CategoricalArrays")
    jlcall("categorical",as.jlValue(as.character(fa)))
}