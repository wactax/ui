#!/usr/bin/env coffee

> ./env > LIB_INDEX
  ./merge_import
  @tanishiking/aho-corasick > Trie Emit
  @w5/read
  @w5/uridir
  base-x:BaseX
  fs
  fs/promises > writeFile
  path > join dirname
  stream/promises > pipeline

li = []

+ prefix

func_var = (li)=>
  r = []
  func_this = [
  ]
  func_no_this = [
    '''const $shadowRoot = (e0)=>e0.shadowRoot;'''
  ]
  for i in li
    i = i.replace 'function prevent_default(fn)', 'const prevent_default =(fn)=>'
    if i.startsWith 'function '
      t = [i]
      no_this = true
    else if i.startsWith 'var ' and i.endsWith ';'
      func_no_this.push i
    else if t
      t.push i
      if i == '}'
        if no_this
          fn = t[0]
          tmp = fn[9..]
          p = tmp.indexOf('(')
          name = tmp[...p].trim()
          other = tmp[p..]
          t[0] = 'const '+name+'='+other
        t = t.join('\n')+'\n'
        if no_this
          t = t.replace(') {',')=>{')
          insert = func_no_this
        else
          insert = func_this
        insert.push(t)
        t = undefined
      else if /\bthis\b/.test(i)
        no_this = false
    else
      r.push i

  cmp = (a,b)=>b.length-a.length
  func_this.sort cmp
  func_no_this.sort cmp
  [
    ...func_this.join('\n').split('\n')
    ...func_no_this.join('\n').split('\n')
    ...r
  ]

attr_func = (iter)=>
  for await line from iter
    line = line.replaceAll('document', '$DOC')

    pos = line.indexOf '.innerHTML ='
    if pos > 0 and line.endsWith(';')
      line = '$innerHTML('+line[..pos-1]+','+line[pos+12...-1]+');'
    li.push line

  li.unshift """
const $innerHTML = (elem,html)=>elem.innerHTML = html
const $DOC = document;
"""

  li

B52 = BaseX 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'

rename = (js, li)=>
  short = new Map()
  for i,pos in li
    short.set i, B52.encode [pos]
  trie = new Trie(
    [...short.keys()]
    onlyWholeWords: true
    allowOverlaps: false
  )
  pos = 0
  t = []
  for {start,end,keyword} from trie.parseText js
    if js[start-1] == '_'
      continue
    t.push js[pos...start]
    t.push short.get(keyword)
    pos = end+1
  t.push js[pos..]
  t.join('')

rename_attr = (li)=>
  replace = []
  for line from li
    if t
      if line.endsWith('};')
        replace.push t
        t = undefined
      else
        pos = line.indexOf(':')
        if pos > 0
          t.push line[..pos-1].trim()
        else if line.endsWith ','
          t.push line[...-1].trim()
    else if line.endsWith('component.$$ = {')
      t = []

  js = li.join('\n')
  replace[0].splice(0,0,...'target anchor customElement'.split(' '))
  for l from replace
    js = rename(js, l)

  js

await do =>
  code = MergeImport(
    read LIB_INDEX
  ).split('\n')

  code = rename_attr(
    func_var(await attr_func(code))
  ).replace(
    'throw Error("Function called outside component initialization")'
    ''
  ).replace(
    /([\w\.]+).shadowRoot,/g
    '$shadowRoot($1),'
  ).replaceAll(
    'typeof HTMLElement === "function"'
    'true'
  ).replaceAll(
    'typeof window !== "undefined"'
    'true'
  )

  await writeFile LIB_INDEX, code
  return
