#!/usr/bin/env bash

DIR=$(dirname $(realpath "$0"))
cd $DIR
set -ex
case "$(uname -sr)" in

  Darwin*)
    echo 'Mac OS X'
    if ! [ -x "$(command -v brew)" ]; then
      bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    if ! [ -x "$(command -v openresty)" ]; then
      brew install brotli lua pcre2 pcre
      brew tap openresty/brew
      brew install openresty/brew/openresty
      #brew tap denji/nginx
      #brew install nginx-full \
      #  --with-gzip-static \
      #  --with-http2 \
      #  --with-lua-module \
      #  --with-set-misc-module # \
      #  --with-brotli-module
    fi
    ;;

  Linux*Microsoft*)
    echo 'WSL'  # Windows Subsystem for Linux
    ;;

  Linux*)
    echo 'Linux'
    ;;

  CYGWIN*|MINGW*|MINGW32*|MSYS*)
    echo 'MS Windows'
    ;;

   # Add here more strings to compare
   # See correspondence table at the bottom of this answer

   *)
   echo 'Other OS'
   ;;
esac

