express = require 'express'
algo = require "./algo"

process = algo.homework

logformat = {format: '>\t:method :url \t\":req[content-type]\" \n<\t:status \t\":req[content-type]\" \t:response-timems'}

app = express.createServer(
    express.logger(logformat),
    express.bodyDecoder('application/json')
)

app.get('/', (req, res) ->
    res.contentType('text/plain; charset=utf8')
    res.send 'POST me some JSON'
)

app.post('/', (req, res) ->
    res.contentType('application/json; charset=utf8')
    res.send JSON.stringify(process req.body)
)

app.listen(8000);
