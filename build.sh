#!/usr/bin/env bash

DIR=$(dirname $(realpath "$0"))
cd $DIR
set -ex

mkdir -p lib/gen

bunx cep -c ./conf >/dev/null &
direnv exec ./sh/index.js.gen.coffee &
rsync -qav ../styl/lib/ lib &

rsync -qav --include="*/" \
  --include="*.js" \
  --exclude="*" \
  ./node_modules/wtax/* lib/wtax/ &

try_wait() {
  wait ||
    {
      echo "error : $?" >&2
      exit 1
    }
}

try_wait

bunx svelteup --config conf/svelteup.config.js
rm -rf src/index.js

RSYNC_ONCE=1 direnv exec ./sh/rsync.coffee

direnv exec ./sh/hook.esbuild.coffee &
direnv exec ./sh/hook.merge.coffee &

try_wait

direnv exec ./sh/fix.path.coffee
direnv exec ./sh/svelte_module.coffee
rm -rf conf/svelteup.config.bundled_*.mjs &
