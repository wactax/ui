#!/usr/bin/env bash

DIR=$(dirname $(realpath "$0"))
set -ex

#./sh/build.config.sh

rm -rf lib

./demo.sh

cd $DIR
bunx concurrently \
  -r --kill-others \
  "direnv exec ../styl/dev.sh" \
  "bunx stylus -w -o lib/demo demo/file/*.styl" \
  "bunx pug -w -o lib/demo demo/file/index.pug" \
  "./preview.sh" \
  "./dev.svelte.sh"
