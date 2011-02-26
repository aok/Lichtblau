sys = require "sys"
http = require "http"
algo = require "./algo"

process = algo.homework

doget = (req,res) ->
	res.writeHead 400, {"Content-Type": "text/plain"}
	res.write "Post me some JSON\n"
	res.end()

dopost = (req,res) ->
	req.content = ""

	req.on("data", (chunk) ->
		req.content += chunk
	)
#
	req.on("end", ->
		result = JSON.stringify process JSON.parse req.content
		res.writeHead 200, {"Content-Type": "application/json"}
		res.write result+'\n'
		res.end()
	)

http.createServer((req, res) ->
	console.log JSON.stringify req.headers
	if req.method is 'POST'
		dopost(req,res)
	else
		doget(req,res)
).listen 8000

console.log "Server running at http://127.0.0.1:8000/"