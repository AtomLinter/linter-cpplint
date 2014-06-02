path = require 'path'

module.exports =
  configDefaults:
    cpplintExecutablePath: path.join __dirname, '..', 'bin'

  activate: ->
    console.log 'activate linter-cpplint'
