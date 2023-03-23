import {join} from 'path'
import fs from 'fs'
import autoprefixer from 'autoprefixer'
import px2em from 'postcss-plugin-px2em'
import csso from 'postcss-csso'

li = [
  autoprefixer
  px2em {
    rootValue: 16
    minPixelValue: 5
  }
]

export default li

if process.env.NODE_ENV == 'production'
  li.push csso
