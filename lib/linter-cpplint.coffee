linterPath = atom.packages.getLoadedPackage("linter").path
Linter = require "#{linterPath}/lib/linter"
path = require 'path'

class LinterCpplint extends Linter
  # The syntax that the linter handles. May be a string or
  # list/tuple of strings. Names should be all lowercase.
  @syntax: ['source.c++']

  # A string, list, tuple or callable that returns a string, list or tuple,
  # containing the command line (with arguments) used to lint.
  cmd: 'cpplint --extensions=c++ --reporter=plain-text'

  linterName: 'cpplint'

  # A regex pattern used to extract information from the executable's output.

  regex: '[^:]+:(?<line>\\d+):\\s+(?<message>.*)'

  defaultLevel: 'warning'

  isNodeExecutable: yes

  executablePath: path.join __dirname, '..', 'node_modules', 'node-cpplint', 'bin'

  constructor: (editor) ->
    super(editor)

  # Private: cpplint outputs line 0 for some errors. This needs to be changed to
  # line 1 otherwise it will break.
  createMessage: (match) ->
    match.line = if match.line > 0 then match.line else 1
    return super match

  destroy: ->
    atom.config.unobserve 'linter-cpplint.cpplintExecutablePath'

module.exports = LinterCpplint
