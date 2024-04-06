as.jlValue.factor <- function(fa, ...) {
    jlusing("CategoricalArrays")
    jlcall("categorical",jlValue_eval(as.character(fa)))
}