#!/bin/sh

devtools::install_github("hadley/r4ds")
devtools::install_github("cienciadedatos/datos")
Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::gitbook')"

