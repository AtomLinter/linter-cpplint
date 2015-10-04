path = require 'path'

module.exports =
  config:
    lineLength:
      type: 'integer'
      default: '80'
    filters:
      type: 'string'
      default: ''
    extensions:
      type: 'string'
      default: 'c++,cc,cpp,cu,cuh,h,hpp'
    executablePath:
      type: 'string'
      default: path.join __dirname, '..', 'bin', 'cpplint.py'

  activate: ->
    require('atom-package-deps').install 'linter-cpplint'

  provideLinter: ->
    LinterCpplint = require './linter-cpplint.coffee'
    @provider = new LinterCpplint()
    return {
      grammarScopes: ['source.cpp']
      scope: 'file'
      # cpplint only lint file(s).
      lintOnFly: false
      lint: @provider.lint
    }
