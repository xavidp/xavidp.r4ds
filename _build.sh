#!/bin/sh

Rscript -e 'devtools::install_github("hadley/r4ds")'
Rscript -e 'try(remove.packages("datos")); devtools::install_github("pachamaltese/datos")'

Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::gitbook')"
