#!/bin/sh

git checkout traduccion

R --vanilla << EOF

if (!require("pacman")) { install.packages("pacman") }
pacman::p_load_current_gh(c("pachamaltese/r4ds"))

bookdown::render_book('index.Rmd', 'bookdown::gitbook')

q()
EOF

git push origin --delete gh-pages

git add . && git commit -m "weekly build `date +'%Y-%m-%d %H:%M:%S'`"

git subtree push --prefix docs origin gh-pages
