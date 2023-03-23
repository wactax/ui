#!/usr/bin/env coffee

> ./env > LIB SRC
  path > join
  @w5/write
  fs > existsSync
  ./hook:@ > DIR

hook.merge (dir, name_li)=>

  for name from name_li
    n = 0
    out_import = []
    out_export = []

    for i from DIR
      js = i+'/'+name+'.js'
      if existsSync(join(LIB, js))
        m = 'm'+n
        out_import.push "import #{m} from '!/#{js}'"
        out_export.push m

    write(
      join LIB, dir, 'gen', name+'.js'
      out_import.join('\n')+'\nexport default ['+out_export.join(',')+']'
    )

  return
