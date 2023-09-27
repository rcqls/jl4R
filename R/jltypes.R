jlvalue <- function(obj, ...) UseMethod("jlvalue")

jlvalue.default <- function(obj) obj

jlvalue.DataFrame <- function(jlval) {
    #.jleval(.jlmethod("names",jlval))
}