> @w5/uridir
  path > dirname join

export DIR = uridir(import.meta)
export ROOT = dirname DIR
export SRC = join ROOT,'src'
export LIB = join ROOT,'lib'
export LIB_INDEX = join LIB,'index.js'
