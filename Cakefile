fs = require "fs"
path = require "path"
{spawn, exec} = require "child_process"
#stdout = process.stdout

# ANSI Terminal Colors.
bold    = "\033[0;1m"
red     = "\033[0;31m"
green   = "\033[0;32m"
reset   = "\033[0m"

# Log a message with a color.
log = (message, color='', explanation='') ->
    console.log color + message + reset + ' ' + explanation

# Handle error and kill the process.
onerror = (err) ->
    if err
        process.stdout.write "#{red}#{err.stack}#{reset}\n"
        process.exit -1

bkgrnd = (cmd, args) ->
    cmd = spawn(cmd, args)
    cmd.stdout.on "data", (data)-> log data, green
    cmd.on "error", onerror

task "watch", "Compile coffeescript on change", ->
    bkgrnd("coffee", ["-cw", "-o", "build", "src", "spec"])

task "server", "Run server and reload when sources change", ->
    bkgrnd("node-dev", ["build/server.js"])

runTests = (callback)->
    log "Running test suite ...", green
    exec "vows --spec spec/*-spec.coffee", (err, stdout, stderr) ->
        process.stdout.write stdout
        process.binding('stdio').writeError stderr
        callback err if callback

task "test", "Run all tests", ->
    runTests (err)->
        process.stdout.on "drain", -> process.exit -1 if err

#option '-f', '--inputfile [FILE]', 'file to read from'
#
#prettyprint = (inputfile='spec/round-config.json') ->
#	pretty = ''
#	fs.readFile(inputfile, (err, contents) ->
#		JSON.stringify contents
#	)
#
#task "prettyprint", "read json and pretty-print it back", (options) ->
#	prettyprint options.inputfile



