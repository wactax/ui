#!/usr/bin/env coffee

> ./env > LIB
  @w5/walk
  @w5/read
  @w5/write
  path > join

for await fp from walk LIB
  rel = =>
    dir = fp[LIB.length+1..]
    (
      '../'.repeat(
        dir.split('/').length-1
      ) or './'
    )

  if fp.endsWith '.js'
    change = 0

    js = read(fp).replace(
      / from ('|")\!\//g
      (line, q)=>
        change = 1
        ' from '+q+rel()
    ).replace(
      /^import ('|")\!\//g
      (line, q)=>
        change = 1
        'import '+q+rel()
    ).replace(
      / from ('|")wtax\//g
      (line, q)=>
        change = 1
        ' from '+q+rel()+'wtax/'
    )
    .replace(
      /import ('|")wtax\//g
      (line, q)=>
        change = 1
        'import '+q+rel()+'wtax/'
    )

    if change
      write fp, js
