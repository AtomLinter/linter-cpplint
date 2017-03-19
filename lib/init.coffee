{CompositeDisposable} = require 'atom'
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
      default: 'cpplint'

  activate: ->
    require('atom-package-deps').install('linter-cpplint')

    @subscriptions = new CompositeDisposable

    @subscriptions.add atom.config.observe 'linter-cpplint.executablePath',
    (executablePath) =>
      @cpplintPath = executablePath

    @subscriptions.add atom.config.observe 'linter-cpplint.lineLength', =>
      @updateParameters()

    @subscriptions.add atom.config.observe 'linter-cpplint.filters', =>
      @updateParameters()

    @subscriptions.add atom.config.observe 'linter-cpplint.extensions', =>
      @updateParameters()

  deactivate: ->
    @subscriptions.dispose()

  provideLinter: ->
    helpers = require('atom-linter')
    provider =
      name: 'cpplint'
      grammarScopes: ['source.cpp']
      scope: 'file'
      # cpplint only lints file(s).
      lintOnFly: false
      lint: (textEditor) =>
        filePath = textEditor.getPath()
        parameters = @parameters.slice()

        # File path is the last parameter.
        parameters.push(filePath)

        execOpt =
          stream: 'stderr'
          allowEmptyStderr: true
          cwd: path.dirname(filePath)

        return helpers
            .exec(@cpplintPath, parameters, execOpt).then (result) ->
          toReturn = []
          regex = /.+:(\d+):(.+)\[\d+\]/g

          while (match = regex.exec(result)) isnt null
            message = match[2]

            # cpplint line is 1-based. Line 0 is for copyright and header_guard.
            line = parseInt(match[1]) or 1
            line = Math.max(0, line - 1)

            range = helpers.generateRange(textEditor, line)

            toReturn.push({
              type: 'Warning'
              text: message
              filePath: filePath
              range: range
            })
          return toReturn

  updateParameters: ->
    lineLength = atom.config.get 'linter-cpplint.lineLength'
    filters = atom.config.get 'linter-cpplint.filters'
    extensions = atom.config.get 'linter-cpplint.extensions'
    parameters = []
    if lineLength
      parameters.push('--linelength', lineLength)
    if filters
      parameters.push('--filter', filters)
    if extensions
      parameters.push('--extensions', extensions)
    @parameters = parameters
