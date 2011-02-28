express = require 'express'
algo = require "./algo"

process = algo.homework

app = express.createServer(
	express.logger()
	express.bodyDecoder('application/json')
)

app.get('/', (req, res) ->
	res.send 'POST me some JSON\n'
)

app.post('/', (req, res) -> 
	res.send JSON.stringify(process req.body)+'\n'
)

app.listen(8000);
