import {DEV} from './env'
import UglifyJS from 'uglify-js'

OPT = {
  compress: {
    unsafe: true
    toplevel: true
    drop_console: !DEV
    module: true
    passes: 3
  }
  mangle: {
    toplevel: true
    properties: {
      #debug: true
      #builtins: false
      regex: /^\$/
    }
  }
  module: true
  sourceMap: false
}


export default (code, opt={})=>
  UglifyJS.minify(
    code
    {
      ...OPT
      ...opt
    }
  )

