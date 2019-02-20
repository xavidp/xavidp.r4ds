#!/bin/sh

sudo apt install pandoc

git checkout traduccion

R --vanilla << EOF

source("packrat/init.R")
bookdown::render_book('index.Rmd', 'bookdown::gitbook')

q()
EOF

cp CNAME docs/CNAME

git add . && git commit -m "weekly build `date +'%Y-%m-%d %H:%M:%S'`"

git push && git subtree push --prefix docs origin gh-pages
