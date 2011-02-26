fs            = require("fs")
path          = require("path")
{spawn, exec} = require("child_process")
stdout        = process.stdout

# ANSI Terminal Colors.
bold  = "\033[0;1m"
red   = "\033[0;31m"
green = "\033[0;32m"
reset = "\033[0m"

# Log a message with a color.
log = (message, color, explanation) ->
  console.log color + message + reset + ' ' + (explanation or '')


# Handle error and kill the process.
onerror = (err)->
  if err
    process.stdout.write "#{red}#{err.stack}#{reset}\n"
    process.exit -1


task "watch", "Continously compile CoffeeScript and run it", ->
  cmd = spawn("coffee", ["-cw", "-o", "build", "src"])
  cmd.stdout.on "data", (data)-> process.stdout.write green + data + reset
  cmd.on "error", onerror



runTests = (callback)->
  log "Running test suite ...", green
  exec "vows --spec spec/*-spec.coffee", (err, stdout, stderr) ->
    process.stdout.write stdout
    process.binding('stdio').writeError stderr
    callback err if callback

task "test", "Run all tests", ->
  runTests (err)->
    process.stdout.on "drain", -> process.exit -1 if err