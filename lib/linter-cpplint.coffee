linterPath = atom.packages.getLoadedPackage("linter").path
Linter = require "#{linterPath}/lib/linter"

class LinterCpplint extends Linter
  # The syntax that the linter handles. May be a string or
  # list/tuple of strings. Names should be all lowercase.
  @syntax: ['source.c++', 'source.c']

  # A string, list, tuple or callable that returns a string, list or tuple,
  # containing the command line (with arguments) used to lint.
  cmd: 'cpplint'

  linterName: 'cpplint'

  # A regex pattern used to extract information from the executable's output.

  #/home/android.h:4:  Include the directory when naming .h files  [build/include] [4]
  regex: '\\D+(?<line>\\d+):\\s+(?<message>.+)\\n'

  defaultLevel: 'warning'

  isNodeExecutable: yes

  constructor: (editor) ->
    super(editor)

    console.log 'constructor linter-cpplint'

    atom.config.observe 'linter-cpplint.cpplintExecutablePath', @formatShellCmd

  formatShellCmd: =>
    cpplintExecutablePath = atom.config.get 'linter-cpplint.cpplintExecutablePath'
    console.log cpplintExecutablePath
    @executablePath = "#{cpplintExecutablePath}"

  destroy: ->
    atom.config.unobserve 'linter-cpplint.cpplintExecutablePath'

module.exports = LinterCpplint
