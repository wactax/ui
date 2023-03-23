> @w5/walk > walkRel
  path > join extname dirname
  ./env > SRC ROOT LIB

external = [
  './*.js'
  '../*.js'
  'wtax/*.js'
  '!/*.js'
]

#for await i from walkRel(
#  SRC
#  (i)=>
#    [
#      'node_modules'
#      '.git'
#    ].includes i
#)
#  pos = i.lastIndexOf('.')
#  if pos > 0
#    ext = i[pos+1..]
#    if ~ [
#      'js'
#      'coffee'
#    ].indexOf ext
#      i = '/'+i[...pos]+'.js'
#      external.push('.'+i)
#      external.push('!'+i)
#      #external.push('~'+i)

#console.log {external}

< {
  external
  nodePaths:[
    join ROOT, 'node_modules'
  ]
  plugins: [
    #{
    #  name: 'alias',
    #  setup:(build) =>
    #    # we do not register 'file' namespace here, because the root file won't be processed https://github.com/evanw/esbuild/issues/791
    #    build.onResolve(
    #      { filter: /^\..*\.js$/ }
    #      (args) =>
    #        {path, resolveDir} = args
    #        if resolveDir.startsWith SRC
    #          resolveDir = LIB+resolveDir[SRC.length..]
    #        else if resolveDir.startsWith PKG
    #          resolveDir = LIB+resolveDir[PKG.length..-4]

    #          console.warn '>>>>', join(resolveDir, path), resolveDir, path

    #        path = join(resolveDir, path)
    #        {
    #          path
    #          #namespace:'~'
    #        }
    #    )
    #    return
    #}
  ]
}
