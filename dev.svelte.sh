#!/usr/bin/env bash

DIR=$(dirname $(realpath "$0"))
set -ex

#./sh/build.config.sh

cd $DIR
bunx nodemon \
  --watch 'src' \
  --watch '../styl/src' \
  -e coffee,svelte,styl,svg,pug --exec ./build.sh
