#!/bin/sh

sudo apt install pandoc

git checkout traduccion

R --vanilla << EOF

if (!require("pacman")) { install.packages("pacman") }

pacman::p_load_current_gh(c("pachamaltese/r4ds"))

bookdown::render_book('index.Rmd', 'bookdown::gitbook')

q()
EOF

git add . && git commit -m "weekly build `date +'%Y-%m-%d %H:%M:%S'`"

git push && git subtree push --prefix docs origin gh-pages
