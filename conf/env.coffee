> path > join dirname
  @w5/uridir

{
  #  USER_TAX_CDN:CDN
  NODE_ENV
} = process.env

#export CDN = CDN or '//user0.ga/'
export DEV = NODE_ENV != 'production'
export ROOT = dirname uridir import.meta
export LIB = join ROOT,'lib'
export SRC = join ROOT,'src'
