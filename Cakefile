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
log = (message, color, explanation) ->
    console.log color + message + reset + ' ' + (explanation or '')

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
    bkgrnd("coffee", ["-cw", "-o", "build", "src"])

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

postfile = (datafile='spec/data.json') ->
    http = require "http"
    options = {
        host: 'localhost',
        port: 8000,
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=utf-8'
        }
    }
    req = http.request(options, (res) ->
        log res.statusCode, green
        res.setEncoding 'utf8'
        res.on('data', (chunk) ->
            log chunk, green
        )
    )
    fs.readFile(datafile, (err, data) ->
        throw err if err
        req.write data
        req.end()
    )

task "post", "post example json to server", ->
    postfile()
