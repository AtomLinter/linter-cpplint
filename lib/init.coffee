path = require 'path'

module.exports =
  configDefaults:
    filters: ''
    extensions: 'c++'
    cpplintExecutablePath: path.join __dirname, '..', 'bin'

  activate: ->
    console.log 'activate linter-cpplint'
