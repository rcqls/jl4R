#!/bin/bash
Rscript -e "rmarkdown::render('inst/README.Rmd')"
mv inst/README.md .
rm inst/README.html
