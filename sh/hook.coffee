#!/usr/bin/env coffee

> ./env > LIB SRC
  path > join
  @w5/write
  fs > lstatSync readdirSync readlinkSync existsSync

< DIR = do =>
  li = []
  for dir from readdirSync SRC
    dp = join SRC, dir
    st = lstatSync(dp)
    if st.isSymbolicLink()
      dp = join(SRC, readlinkSync dp)
      st = lstatSync(dp)

    if st.isDirectory()
      li.push dir
  li

< new Proxy(
  {}
  get:(_,filename)=>
    (run)=>
      for dir from DIR
        m = join LIB,dir,'.hook/'+filename+'.js'
        if existsSync m
          {default:m} = await import(m)
          run dir,m
      return
)
