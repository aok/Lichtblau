sys = require "sys"
http = require "http"

collect = (req) ->
	req.content = ''
	req.on("data", (chunk) ->
		req.content += chunk)

process = (data) ->
	obj = JSON.parse data
	JSON.stringify [obj?.c[0]?.id,3]

respond = (res) ->
	res.writeHead 200, {"Content-Type": "text/plain"}
	res.write res.content+"\n"
	res.end()

http.createServer((req, res) ->
	collect req
	req.on("end", ->
		res.content = process req.content	
		respond res)
).listen 8000

console.log "Server running at http://127.0.0.1:8000/"
	