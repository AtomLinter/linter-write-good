path = require 'path'
{XRegExp} = require 'xregexp'
{BufferedProcess, CompositeDisposable} = require 'atom'

writeGoodRe = '[^^]*(?<offset>\\^+)[^^]*\n(?<message>.+?) on line (?<line>\\d+) at column (?<col>\\d+)\n?'

module.exports =
  config:
    writeGoodPath:
      type: 'string'
      title: 'Path to the write-good executable. Defaults to a built-in write-good.'
      default: path.join __dirname, '..', 'node_modules', 'write-good', 'bin', 'write-good.js'
    additionalArgs:
      type: 'string'
      title: 'Additional arguments to pass to write-good.'
      default: ''
    nodePath:
      type: 'string'
      title: 'Path to the node interpreter to use. Defaults to Atom\'s.'
      default: path.join atom.packages.getApmPath(), '..', 'node'

  activate: ->
    @subscriptions = new CompositeDisposable

    @subscriptions.add atom.config.observe 'linter-write-good.writeGoodPath',
      (writeGoodPath) =>
        @writeGoodPath = writeGoodPath

    @subscriptions.add atom.config.observe 'linter-write-good.nodePath',
      (nodePath) =>
        @nodePath = nodePath

    @subscriptions.add atom.config.observe 'linter-write-good.additionalArgs',
      (additionalArgs) =>
        @additionalArgs = if additionalArgs
          additionalArgs.split ' '
        else
          []

  deactivate: ->
    @subscriptions.dispose()

  provideLinter: ->
    provider =
      grammarScopes: [
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

      scope: 'file' # or 'project'

      lintOnFly: true # must be false for scope: 'project'

      lint: (textEditor) =>
        return new Promise (resolve, reject) =>
          filePath = textEditor.getPath()

          output = ""

          process = new BufferedProcess
            command: @nodePath

            args: [@writeGoodPath, filePath, @additionalArgs...]

            stdout: (data) ->
              output += data

            exit: (code) ->
              messages = []
              regex = XRegExp writeGoodRe, @regexFlags

              XRegExp.forEach output, regex, (match, i) ->
                match.colStart = parseInt(match.col)
                match.lineStart = parseInt(match.line) - 1
                match.colEnd = match.colStart + match.offset.length
                messages.push
                  type: 'Error'
                  text: match.message
                  filePath: filePath
                  range: [
                    [match.lineStart, match.colStart]
                    [match.lineStart, match.colEnd]
                  ]

              resolve messages

          process.onWillThrowError ({error,handle}) ->
            atom.notifications.addError "Failed to run #{@nodePath} #{@writeGoodPath}",
              detail: "#{error.message}"
              dismissable: true
            handle()
            resolve []
