#!/usr/bin/env coffee

> @w5/uridir
  path > dirname extname join
  chalk
  @w5/read
  @w5/write
  fs > copyFileSync symlinkSync existsSync lstatSync unlinkSync mkdirSync rmSync statSync chmodSync constants readdirSync renameSync
  fs-extra:fsExtra
  coffeescript
  chokidar
  @w5/coffee_plus
  ./env > SRC LIB

{RSYNC_ONCE, NODE_ENV} = process.env

DEV = NODE_ENV != 'production'

if DEV
  symlinkOrCp = symlinkSync
else
  symlinkOrCp = (src, lib)=>
    copyFileSync(
      join dirname(lib), src
      lib
    )

{ copySync } = fsExtra

{gray} = chalk

coffeescript.compile = CoffeePlus coffeescript

SRC_LEN = SRC.length+1
COFFEE = 'coffee'
IGNORE = 'svelte'

coffee_js = (fp)=>
  fp[..-7]+'js'

#readdirSync(SRC).forEach(
#  (i)=>
#    fp = join SRC,i
#    stat = lstatSync(fp)
#    if stat.isSymbolicLink()
#      DIR_LI.push fp
#    return
#)

IGNORE = new Set [
  'svelte'
]

add = (fp)=>
  lib = join LIB, fp
  dir = dirname lib

  if not existsSync dir
    mkdirSync(dir, { recursive: true })

  ext = extname(fp)[1..]
  if IGNORE.has ext
    return
  if ext == COFFEE
    lib = coffee_js lib
    sfp = join(SRC, fp)
    write(
      lib
      coffeescript.compile(
        read sfp
        bare: true
      )
    )
    if (statSync sfp).mode & constants.S_IXUSR
      chmodSync(lib, 0o755)
  else if not existsSync lib
    src = '../'.repeat(
      1+fp.length - fp.replaceAll('/','').length
    )+'src/'+fp
    symlinkOrCp(src,lib)
  return

change = (path)=>
  fp = path[SRC_LEN..]
  add(fp)
  return

log = (str...)=>
  console.log gray(...str)
  return

READY = 0

ON = {
  change
  add: change

  unlinkDir:(path)=>
    fp = path[SRC_LEN..]
    lib = join LIB,fp
    log '⌦',lib
    rmSync lib,recursive:true,force:true
    return

  unlink:(path)=>
    if IGNORE.has ext
      return
    fp = path[SRC_LEN..]
    ext = extname(fp)[1..]
    if ext == COFFEE
      fp = coffee_js fp
    lib = join LIB,fp
    log '⌦',lib
    try
      unlinkSync lib
    catch err
      console.error err
    return

  ready:=>
    ###
    setTimeout(
      =>
        Init = join LIB, '_/Init'
        {default:PkgInit} = await import(
          join(Init, 'PkgInit.js')
        )
        dir_pkg = 'Redis/pkg'
        src_pkg = join SRC,dir_pkg
        await PkgInit ['redis']

        {default:run} = await import(
          join(Init,'run.js')
        )
        {GEN} = await import(
          join(Init,'main.js')
        )
        await run GEN
        return
    )
    ###

    _add = add
    add = (fp)=>
      log '✏',fp
      _add(fp)
      return
    if RSYNC_ONCE
      process.exit()
    return
}


w = chokidar.watch(
  [SRC]
  ignored:(p, stat)=>
    if p.endsWith('/.git')
      return true
    if p.endsWith('/node_modules')
      return true
    return
  persistent: true
  #followSymlinks: true
)

for [e,f] from Object.entries ON
  w.on(e,f)
