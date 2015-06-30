{CompositeDisposable} = require 'atom'
linterPath = atom.packages.getLoadedPackage('linter').path
Linter = require "#{linterPath}/lib/linter"
findFile = require "#{linterPath}/lib/util"
{XRegExp} = require 'xregexp'

class LinterWriteGood extends Linter
  # The syntax that the linter handles. May be a string or
  # list/tuple of strings. Names should be all lowercase.
  @syntax: [
    "source.gfm"
    "gfm.restructuredtext"
    "text.git-commit"
    "text.plain"
    "text.plain.null-grammar"
    "text.restructuredtext"
    "text.bibtex"
    "text.tex.latex"
    "text.tex.latex.beamer"
    "text.log.latex"
    "text.tex.latex.memoir"
    "text.tex"
  ]

  # A string, list, tuple or callable that returns a string, list or tuple,
  # containing the command line (with arguments) used to lint.
  cmd: 'write-good.js'

  linterName: 'write-good'

  options: ['additionalArgs']

  # A regex pattern used to extract information from the executable's output.
  regex:
    '[^^]*(?<offset>\\^+)[^^]*\n' +
    '(?<message>.+?) on line (?<line>\\d+) at column (?<col>\\d+)\n?'

    # '<issue line="(?<line>\\d+)"' +
    # # '.+?lineEnd="\\d+"' +
    # '.+?reason="\\[((?<error>error)|(?<warning>warn))\\] (?<message>.+?)"'

  isNodeExecutable: yes

  processMessage: (message, callback) ->
    messages = []
    regex = XRegExp @regex, @regexFlags
    XRegExp.forEach message, regex, (match, i) =>
      match.colStart = parseInt(match.col) + 1
      match.colEnd = match.colStart + match.offset.length
      messages.push(@createMessage(match))
    , this
    callback messages

  constructor: (editor) ->
    super(editor)
    @disposables = new CompositeDisposable

    @disposables.add atom.config.observe(
      'linter-write-good.writegoodExecutablePath',
      (val) =>
        @executablePath = val
    )

  destroy: ->
    @disposables.dispose()

  beforeSpawnProcess: (command, args, options) ->
      {
        command,
        args: args.slice(0, -1).concat(
          if @additionalArgs then @additionalArgs.split(' ') else []
          args.slice(-1)
        )
        options
      }

module.exports = LinterWriteGood
