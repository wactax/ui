#!/usr/bin/env coffee

> esbuild > build
  path > join dirname
  ./env > LIB SRC
  ./hook

external = [
  join LIB,'*.js'
  '!/*.js'
]

bundle = (pkg, js)=>
  fp = join LIB, pkg, js
  dir = dirname fp
  js = fp[dir.length+1..]
  build({
    external
    absWorkingDir: dir
    bundle: true
    logLevel: "info"
    entryPoints: [
      js
    ]
    outdir: dir
    allowOverwrite: true
    #minify: true
    format: "esm"
    nodePaths:[
      join SRC,pkg,'node_modules'
    ]
  }).catch =>
    process.exit(1)

hook.esbuild (pkg, name_li)=>
  await Promise.all name_li.map (i)=>
    bundle pkg, join(i+'.js')
  return

