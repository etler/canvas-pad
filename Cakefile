{exec} = require 'child_process'

option '-w', '--watch', 'watch scripts for changes and rerun commands'

task 'build', 'build server', (options) ->
  exec "coffee #{if options.watch is true then '-w ' else ''} --compile server.coffee"
