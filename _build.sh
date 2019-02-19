#!/bin/sh

Rscript -e 'devtools::install_github("hadley/r4ds")'
Rscript -e 'devtools::install_github("pachamaltese/datos")'

Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::gitbook')"
