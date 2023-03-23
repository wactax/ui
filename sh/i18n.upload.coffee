#!/usr/bin/env coffee

> @w5/ossput
  ./ossLi.mjs
  ./env > ROOT SRC
  path > join basename
  @w5/walk:@ > walkRel
  fs > createReadStream readdirSync readFileSync existsSync
  radix-64:Radia64
  @w5/blake3 > Blake3
  @w5/zipint > zip
  @w5/read
  @w5/write

{encodeInt,decodeToInt} = Radia64()

i18n_dir = join(ROOT,'i18n')

put = (args...)=>
  put = ossput await ossLi(process.env.BUCKET_I18N)
  put ...args

upload = (dir, ver, file_li)=>
  for i from file_li
    fp = join(i18n_dir, dir, i)
    console.log '>', fp
    await put(
      dir+'/'+ver+'/'+i
      =>
        createReadStream fp
      'text/css'
    )
  return

for dir from readdirSync i18n_dir
  if dir == 'demo'
    continue
  else
    js_dir = join SRC, dir
  js_dir = join js_dir,'i18n'

  var_js = join(js_dir,'var.js')
  {ver,posId} = await import(var_js)
  hasher = new Blake3
  hasher.update zip posId

  file_li = []
  work_dir = join(i18n_dir, dir)
  for await i from walkRel work_dir
    if basename(i).startsWith('.')
      continue
    hasher.update readFileSync(join(work_dir,i))
    file_li.push i

  hash_fp = join(js_dir,'.hash')
  hash = Buffer.from(hasher.finalize()).toString('base64')

  + do_write

  if existsSync hash_fp
    if hash != read(hash_fp).trim()
      do_write = 1
      ver = encodeInt(decodeToInt(ver)+1)
  else
    do_write = 1

  if do_write
    await upload dir, ver, file_li
    write(
      hash_fp
      hash
    )
    write(
      var_js
      """\
      export const ver = '#{ver}' // #{decodeToInt ver}
      export const posId = #{JSON.stringify(posId)}
      """
    )

  console.log dir, 'ver', decodeToInt(ver)
