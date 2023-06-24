> @w5/kebab
  wtax/split.js
  path > join dirname
  fs > existsSync writeFileSync
  @w5/replace
  @w5/write
  @w5/read
  @w5/snake > SNAKE
  ./env > SRC ROOT

STYL = join dirname(ROOT),'styl/src'

fixImportLine = (dir, line)=>
  if line.startsWith '.'
    line = './'+join(dir, line)
  line

fixImport = (txt, filename)=>
  if filename.startsWith '../pkg/'
    dir = dirname filename[7..]
    pos = dir.indexOf('/ui',4)
    if pos < 0
      dir = dir[..-3]
    else
      dir = dir[..pos]+dir[pos+3..]
  else
    dir = dirname filename[4..]

  state_import = 0
  li = []
  for line from txt.split '\n'
    line = line.trimEnd()
    if line
      if line.startsWith('> ') or line == '>'
        state_import = 1
        line = '> '+fixImportLine(dir, line[2..].trimStart())
      else if line.trim().charAt(0) == '#'
        continue
      else if state_import
        if line.charAt(0) != ' '
          state_import = 0
        else
          line = '  '+fixImportLine(dir, line.trimStart())
    li.push line
  return li.join('\n')


# https://svelte.dev/docs#compile-time-svelte-preprocess
LI = [
  (code, filename)=> # i18n
    pkg = filename[7..]
    pkg = pkg[...pkg.indexOf('/')]

    i18nCode = await import(
      join(SRC,pkg,'i18n/code.js')
    )

    code = replace(
      code
      '<template lang="pug">'
      '</template>'
      (pug)=>
        pug.replaceAll(
          /(['"\s\(]|\|\s)>([\w_]+)/g
          (m,p1,p2)=>
            # console.log {m,p1,p2}
            "#{p1} {I18N[#{i18nCode[SNAKE p2]}]}"
        )
    )

    code = replace(
      code
      '<script lang="coffee">'
      '</script>'
      (txt)=>
        txt = fixImport(txt, filename)
        + exist_submit

        txt = txt.replace(
          /^submit\s*=\s*[-=]>/gm
          (line)=>
            exist_submit = true
            li = split line,'='
            r = li.join('= _SUBMIT `()=>I18N`,')
            r
        ).replace(
          # onMe onLi onMount
          /^on(Li|Me)([\s(])/mg
          (line)=>
            'onMount => '+line
        )

        mod = []

        if exist_submit
          mod.push './_/_SUBMIT.js:_SUBMIT'
          hasI18n = true
        else
          hasI18n = /\bI18N\[/.test code

        name = "i18nOnMount_"+pkg
        if hasI18n
          mod.push "!/#{pkg}/i18n/onMount.js:"+name

        svelte_mod = new Set

        if hasI18n or /\bonMount\b/.test(txt)
          svelte_mod.add 'onMount'

        if /\btick\b/.test(txt)
          svelte_mod.add 'tick'

        if svelte_mod.size
          mod.push 'svelte > '+[...svelte_mod].join(' ')

        li = []
        if mod.length
          li.push '> '+mod.join('\n  ')

        if hasI18n
          li.push '''+ I18N'''

        li.push txt

        if hasI18n
          li.push """\
          onMount #{name} (o)=>
            I18N = o
            return\n"""
        li.join('\n')
      )
    code

  (code, filename)=> # web component
    if filename.startsWith('..')
      name = filename[7..-8]
      p = name.indexOf('/',1)
      name = name[..p]+name[p+4..]
    else
      name = filename[4..-8]

    key = kebab name[name.lastIndexOf('/')+1..]

    styl = name+'.styl'

    fp = join STYL,styl
    if not existsSync fp
      write fp, ''

    css = read(fp)
    if css.trim()
      code += """<style lang="stylus">@import 'styl/#{styl}'</style>"""

    code + """<svelte:options customElement="u-#{key}"/>"""

]

< ({ content:code, filename }) =>
  for i in LI
    code = await i(code, filename)
  {
    code
  }
