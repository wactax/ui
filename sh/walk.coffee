#!/usr/bin/env coffee

import 'zx/globals'
import uridir from '@w5/uridir'

ROOT = uridir(import.meta)
cd ROOT

export default main = =>
  await $'ls'
  await $'pwd'

if process.argv[1] == decodeURI (new URL(import.meta.url)).pathname
  await main()
  process.exit()

