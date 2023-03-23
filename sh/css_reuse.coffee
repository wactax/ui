#!/usr/bin/env coffee

> @w5/read
  @w5/write
  ./env > SRC LIB_INDEX
  @w5/default:

_CSS_ = '_CSS_'

cssIter = (css)->
  t = []
  n = 0
  for i from css
    if i == '}'
      --n
      if not n
        yield t.join('')+'}'
        t = []
        continue

    if i == '{'
      ++n
    t.push i

  if t.length
    yield t.join('')
  return

PREFIX = 'style.textContent = `'
do =>
  li = read(LIB_INDEX).split('\n')

  pos_set = new Set()
  css = new Map()

  for line,pos in li
    i = line.trim()
    if i.startsWith PREFIX
      # for j from cssIter
      for j from cssIter i[PREFIX.length..-3]
        css.default(
          j
          => new Set
        ).add pos

  line_css = new Map

  pos_set = new Set
  for [k,v] from css.entries()
    if v.size == 1
      css.delete k
    else
      v = [...v].sort((a,b)=>a-b)
      v.forEach (i)=>pos_set.add i

      v = v.join('_')
      css.set k, v
      line_css.default(v,=>[]).push k

  varinit = []
  for [k,v] from line_css.entries()
    v = v.join('')
    s = '\''
    if v.includes(s)
      s = '"'
      if v.includes s
        s = '`'
    varinit.push _CSS_+k+'='+s+v+s

  for pos from pos_set
    exist = new Set
    t = []
    for i from cssIter li[pos].trim()[PREFIX.length..-3]
      if i
        varname = css.get i
        if varname
          if not exist.has varname
            exist.add varname
            t.push '${'+_CSS_+varname+'}'
        else
          t.push i
    li[pos] = PREFIX+t.join('')+'`;'
  li = li.join('\n')

  if varinit.length
    varinit = 'const '+varinit.join(',')+';'
  else
    varinit = ''
  write LIB_INDEX, varinit+li
  return
