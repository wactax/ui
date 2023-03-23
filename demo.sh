#!/usr/bin/env bash

DIR=$(dirname $(realpath "$0"))
set -ex

try_wait(){ wait || \
  {
    echo "error : $?" >&2
    exit 1
  }
}

LIB=$DIR/lib
OUT=$LIB/demo

mkdir -p $OUT
cd $OUT

RP=../../demo/file

ln -s $RP/*.svg $OUT || true
ln -s $RP/*.ico $OUT >/dev/null 2>&1 || true
ln -s $RP/*.js $OUT || true
ln -s $RP/i18n $OUT || true

cd $DIR/demo/file

bunx stylus -o $LIB/demo *.styl
bunx pug -o $LIB/demo index.pug

cd ..

bunx i18n
bunx i18n_bin i18n file/i18n ../i18n/demo

try_wait
