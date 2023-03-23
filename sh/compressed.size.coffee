#!/usr/bin/env coffee

import uridir from '@w5/uridir'
import {brotliCompressSync, constants} from 'zlib'
import {readFile, writeFile} from 'fs/promises'
import {join} from 'path'
import {ROOT} from './env'

index = 'lib/index.js'
js = await readFile join ROOT,index

{
  BROTLI_MAX_QUALITY
  BROTLI_PARAM_MODE
  BROTLI_MODE_TEXT
  BROTLI_PARAM_QUALITY
  BROTLI_PARAM_SIZE_HINT
} = constants

{length} = brotliCompressSync(
  js
  chunkSize: 32 * 1024,
  params: {
    [BROTLI_PARAM_MODE]: BROTLI_MODE_TEXT
    [BROTLI_PARAM_QUALITY]: BROTLI_MAX_QUALITY
    [BROTLI_PARAM_SIZE_HINT]: js.length
  }
)

#await writeFile(
#  join(ROOT,'.include/brotli.md')
#  (Math.round(length*1000/1024)/1000)+''
#)
console.log '\n'+index+' br compressed '+length+' bytes'
