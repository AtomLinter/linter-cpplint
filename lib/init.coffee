path = require 'path'

module.exports =
  config:
    filters:
      type: 'string'
      default: ''
    extensions:
      type: 'string'
      default: 'c++,cc,cpp,cu,cuh,h,hpp'
    cpplintExecutablePath:
      type: 'string'
      default: path.join __dirname, '..', 'bin'

  activate: ->
    console.log 'activate linter-cpplint'
