express = require 'express'
algo = require "./algo"

process = algo.firstThatFits

logformat = {format: '>\t:method :url \t\":req[content-type]\" \n<\t:status \t\":req[content-type]\" \t:response-timems'}

logParameters = (obj) ->
    params = {
        timeout: obj.timeout
        contents: obj.contents.length+' items'
        capacity: obj.capacity
    }
    console.log JSON.stringify params


app = express.createServer(
    express.logger(logformat),
    express.bodyDecoder('application/json')
)

app.get('/', (req, res) ->
    res.contentType('text/plain; charset=utf8')
    res.send 'POST me some JSON'
)

app.post('/', (req, res) ->
    logParameters req.body
    res.contentType('application/json; charset=utf8')
    res.send JSON.stringify(process req.body)
)

app.listen(8000);
