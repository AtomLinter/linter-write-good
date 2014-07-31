path = require 'path'

module.exports =
  configDefaults:
    writegoodExecutablePath: path.join __dirname, '..', 'node_modules', 'write-good', 'bin'

  activate: ->
    console.log 'activate linter-write-good'
