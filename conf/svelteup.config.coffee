> @w5/svelte-preprocess
  path > join dirname
  ./esbuild
  ./markup
  ./postcss
  ./env > DEV SRC ROOT

IGNORE_WARN = new Set(
  'a11y-click-events-have-key-events a11y-missing-content'.split(' ')
)
< {
  entry: join SRC,'index.js'
  outdir: join ROOT, 'lib'
  sourcemap: DEV # true
  servedir: '.'
  compilerOptions: {
    css: 'external'
    customElement: true
  }
  esbuild
  onwarn: (warn) =>
    {code,message} = warn
    if code == 'a11y-missing-attribute'
      return !message.includes('<a>')
    !IGNORE_WARN.has code
  preprocess: [
    # style: ({ content, attributes, filename }) =>
    #  #if attributes.lang != 'stylus'
    #  #  return
    #  {css} = await postcss.process(content,{from:filename})
    #  return {
    #    code:css
    #  }
    {
      markup
    }
    SveltePreprocess({
      babel:
        presets: [
          [
            '@babel/preset-env'
            {
              loose: true
              modules: false
              targets: {
                esmodules: true
              }
            }
          ]
        ]
      sourceMap: true
      coffeescript: {
        label:true
        sourceMap: true
      }
      stylus: true
      pug: {
        basedir: SRC
      }
      postcss
    })
  ]
}
