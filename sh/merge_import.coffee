#!/usr/bin/env coffee

> @w5/default:

_default = 'default'

< (txt)->
  li = []
  exist = new Map
  just_import = new Set

  for line from txt.split(';')
    pos = line.indexOf '\nimport '
    if ~ pos
      end = line.indexOf('"',pos+8)
      end = line.indexOf('"',end+1)
      s = line[pos+8..end-1]
      if s.indexOf('}') < 0
        p = s.lastIndexOf('"')
        file = s[p+1..]
        p = s.lastIndexOf(' from ',p)
        if p < 0
          just_import.add s+'"'
          continue

        word = s[...p]

        m = exist.get file

        if not m
          m = new Map
          exist.set file, m

        wli = m.get _default
        if wli
          wli.push word
        else
          m.set _default, [word]
      else
        file = s[s.lastIndexOf('"')+1..]

        m = exist.get file
        if not m
          m = new Map
          exist.set file, m

        for w from s[1...s.lastIndexOf('}')].split(',').map((i)=>i.trim())
          p = w.split(' as ')
          if p.length == 1
            p = [w,w]
          m.default(
            p[0]
            =>[]
          ).push p[1]

      line = line[..pos]+line[end+1..]

    for m from exist.values()
      for wli from m.values()
        for i from wli[1..]
          re = new RegExp('\\b'+i+'\\b','g')
          line = line.replace(i, wli[0])

    li.push line

  for m from just_import.keys()
    li.unshift 'import '+m
  for [fp, m] from exist.entries()
    default_li = m.get _default
    if default_li
      li.unshift "import #{default_li[0]} from '#{fp}'"
    m.delete _default
    keys = [...m.keys()]
    if keys.length
      t = []
      for k from keys
        x = m.get(k)[0]
        if x!=k
          t.push k+' as '+x
        else
          t.push k
      li.unshift 'import {'+t.join(',')+'} from \''+fp+'\''

  return li.join(';')
