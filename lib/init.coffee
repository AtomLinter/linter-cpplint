path = require 'path'

module.exports =
  configDefaults:
    filters: ''
    extensions: 'c++,cc,cpp,cu,cuh,h,hpp'
    cpplintExecutablePath: path.join __dirname, '..', 'bin'

  activate: ->
    console.log 'activate linter-cpplint'
