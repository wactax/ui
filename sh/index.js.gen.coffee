#!/usr/bin/env coffee

import {createWriteStream} from 'fs'
import uridir from '@w5/uridir'
import {dirname,join} from 'path'
import {walkRel} from '@w5/walk'
import intoStream from 'into-stream'
import { pipeline } from 'stream/promises'
> @w5/read

DIR = uridir(import.meta)
ROOT = dirname DIR
SRC = join ROOT,'src'

await pipeline(
  intoStream do ->
    for await i from walkRel(
      SRC
      (i)=>
        i=='styl'
    )
      if i.endsWith('.svelte')
        yield "import './#{i}';\n"
    #yield await read join(SRC,'mod.js')
  createWriteStream join SRC,'index.js'
)

