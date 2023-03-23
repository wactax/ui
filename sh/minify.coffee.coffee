#!/usr/bin/env coffee

> fs > existsSync
  ../conf/minify
  @w5/walk
  merge-source-map:merge
  fs/promises:fs
  @w5/uridir
  path > dirname basename join

ROOT = dirname uridir import.meta

read = (fp) =>
  fs.readFile(fp, 'utf8')

json = (fp) =>
  JSON.parse(await read(fp))

merge_map = (lib, js_path, ext) =>
  {
    code,
    map,
    error
  } = minify(
    await read(js_path)
    sourceMap: true
  )
  if error
    console.log error
    throw new Error(error)
  js_path_map = js_path + '.map'
  if existsSync(js_path_map)
    js = await json(js_path_map)
    map = merge(js, map)
  await fs.writeFile(js_path_map, JSON.stringify(map))
  await fs.writeFile(
    js_path,
    code # + "\n//# sourceMappingURL=#{basename js_path}.map"
  )

for dir in ['lib']
  dir = join(ROOT, dir)
  for await i from walk(dir)
    ext = i.split('.').pop()
    if ~['js'].indexOf(ext)
      merge_map(dir, i, ext)



