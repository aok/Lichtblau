express = require 'express'

app = express.createServer()
app.use express.bodyDecoder('application/json')

app.get('/', (req, res) ->
	res.send 'POST me some JSON'
)

app.post('/', (req, res) -> 
	#obj = JSON.parse req.body
	#res.send JSON.stringify [obj?.c[0]?.id,3]
	out = JSON.stringify(req.headers)+'\n\n'
	out += JSON.stringify(req.body)+'\n'
	res.send out
)

app.listen(8000);
