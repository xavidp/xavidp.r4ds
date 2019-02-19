#!/bin/sh

Rscript -e 'devtools::install_github("hadley/r4ds", force = TRUE)'

Rscript -e 'devtools::install_github("cienciadedatos/datos", force = TRUE)'

Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::gitbook')"
