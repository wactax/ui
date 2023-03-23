#!/usr/bin/env bash

export WEBDIR=$(dirname $(realpath "$0"))
cd $WEBDIR


# rsync -av node_modules/wtax/*.js lib/wtax &
#./build.product.sh
# bunx pug index.pug -o lib
PRE=$(lsof -t -i:8888)

if [ "$PRE" != "" ]; then
  kill -9 $PRE || true
fi

set -ex
./sh/open.sh &

# bun dev 会导致css单引号变成双引号，然后svg无法显示
exec openresty -c $WEBDIR/conf/wac.tax.conf
