#!/usr/bin/env bash

DIR=$(dirname $(realpath "$0"))
cd $DIR
set -ex

bunx mdt .

export NODE_ENV=production
rm -rf lib
mkdir -p lib
. ./build.sh
./sh/css_reuse.coffee
#./sh/minify.svelte.coffee

# esbuild --bundle --allow-overwrite --charset=utf8 --target=chrome110 --outdir=lib lib/index.js
#./sh/minify.coffee.coffee
../styl/build.coffee
./sh/compressed.size.coffee
