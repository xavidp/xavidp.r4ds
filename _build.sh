#!/bin/sh

sudo apt install pandoc

git checkout traduccion

if [ -d docs ]; then
  rm -rf docs
fi

git clone --depth=1 --single-branch --branch gh-pages git@github.com:cienciadedatos/r4ds.git docs/

rm -rf docs/*

R --vanilla << EOF

source("packrat/init.R")
bookdown::render_book('index.Rmd', 'bookdown::gitbook')

q()
EOF

cp CNAME docs/CNAME

git add . && git commit -m "weekly build `date +'%Y-%m-%d %H:%M:%S'`" && git push

cd docs && git add . && git commit -m "weekly build `date +'%Y-%m-%d %H:%M:%S'`" && git push && cd ..
