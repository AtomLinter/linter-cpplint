{CompositeDisposable} = require 'atom'

class LinterCpplint
  @cpplintPath: ''
  @parameters: []

  constructor: ->
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

  destroy: ->
    @subscriptions.dispose()

  lint: (textEditor) =>
    helpers = require('atom-linter')
    filePath = textEditor.getPath()
    parameters = @parameters.slice()

    # File path is the last parameters.
    parameters.push(filePath)

    return helpers
        .exec(@cpplintPath, parameters, stream: 'stderr').then (result) ->
      toReturn = []
      regex = /.+:(\d+):(.+)\[\d+\]/g

      while (match = regex.exec(result)) isnt null
        line = parseInt(match[1]) or 0
        message = match[2]

        # cpplint line is 1-based. Line 0 is for copyright and header_guard.
        line = Math.max(0, line - 1)

        range = [
          [line, 0]
          [line, textEditor.getBuffer().lineLengthForRow(line)]
        ]

        toReturn.push({
          type: 'Warning'
          text: message
          filePath: filePath
          range: range
        })
      return toReturn

module.exports = LinterCpplint
