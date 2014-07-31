linterPath = atom.packages.getLoadedPackage('linter').path
Linter = require "#{linterPath}/lib/linter"
findFile = require "#{linterPath}/lib/util"

class LinterWriteGood extends Linter
  # The syntax that the linter handles. May be a string or
  # list/tuple of strings. Names should be all lowercase.
  @syntax: [
    "source.gfm"
    "text.git-commit"
    "text.plain"
    "text.plain.null-grammar"
    "text.restructuredtext"
  ]

  # A string, list, tuple or callable that returns a string, list or tuple,
  # containing the command line (with arguments) used to lint.
  cmd: 'write-good.js'

  linterName: 'write-good'

  # A regex pattern used to extract information from the executable's output.
  regex:
    '(?<message>.+?) on line (?<line>\\d+) at column (?<col>\\d+)\n?'

    # '<issue line="(?<line>\\d+)"' +
    # # '.+?lineEnd="\\d+"' +
    # '.+?reason="\\[((?<error>error)|(?<warning>warn))\\] (?<message>.+?)"'

  isNodeExecutable: yes

  constructor: (editor) ->
    super(editor)

    atom.config.observe 'linter-write-good.writegoodExecutablePath', (val) =>
      @executablePath = val

  destroy: ->
    atom.config.unobserve 'linter-write-good.writegoodExecutablePath'

module.exports = LinterWriteGood
