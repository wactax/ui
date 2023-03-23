#!/usr/bin/env coffee

> wtax/split
  fs/promises > writeFile
  @w5/fsline
  @w5/uridir
  ./env > SRC LIB_INDEX
  path > join
  lodash-es > upperFirst camelCase

{ ELEMENT_IGNORE } = process.env

ELEMENT_IGNORE = ELEMENT_IGNORE?.split(' ') or ''

svelte_module = (iter)->
  for await line from iter
    #if line.startsWith 'import {'
      #if line.includes('i18nOnMount') # or line.includes('_SUBMIT')
      #  continue
    if line.startsWith('var ')
      if ~ line.indexOf('class extends')
        line = 'const '+line[4..]
    else if line.startsWith 'customElements.define("'
      t = line[23..]
      pos = t.indexOf('-')+1
      p2 = t.indexOf(',',pos)
      name = t[pos...p2-1]
      cls = t[p2+1..-3].trim()
      if not ELEMENT_IGNORE.includes name
        line = """$ELEMENT("#{name}",#{cls});"""
      else
        console.log 'IGNORE',name
    yield line
  return

await do =>
  UI_PREFIX = "const UI_PREFIX = 'u-';"
  li = [
    UI_PREFIX + '''const $ELEMENT=(name,o)=>customElements.define(UI_PREFIX+name,o);'''
    # + '''import {i18nOnMount} from './_/i18n/wtax.js';'''
  ]
  n = 0
  for await line from svelte_module fsline(LIB_INDEX)
    if n == 0
      if line == UI_PREFIX
        return
    ++n
    li.push line

  js = li.join('\n').replaceAll(
    '"u-'
    'UI_PREFIX+"'
  ).replace(
    /\:global\([^)]+\)/g
    (word)=>
      word[8..-2]
  )
  # .replace(
  #   /i18nOnMount\d+\(/g
  #   'i18nOnMount('
  # )
  await writeFile LIB_INDEX, js
