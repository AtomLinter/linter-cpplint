path = require 'path'

module.exports =
  configDefaults:
    cpplintExecutablePath: path.join __dirname, '..', 'node_modules', 'node-cpplint', 'bin'

  activate: ->
    console.log 'activate linter-cpplint'
