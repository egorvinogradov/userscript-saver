staticServer = require "node-static"
http = require "http"
url = require "url"

webroot = './promo/public'
port = process.env.PORT || 3000

fileServer = new(staticServer.Server) webroot, cache: 600

load_static_file = (request, response) ->
	fileServer.serve request, response, (error, result) ->
		if error
			console.error 'Error serving %s - %s', request.url, error.message
			response.writeHead error.status, error.headers
			response.end 'Error: ' + error.status

load_userscript = (request, response, userscriptId) ->
	userscriptsClient = http.createClient 80, "userscripts.org"

	userscriptUri = "/scripts/source/#{userscriptId}.user.js"
	request = userscriptsClient.request "GET", userscriptUri, "host": "userscripts.org"

	request.addListener "response", (userscriptsResponse) ->
		body = ""
		userscriptsResponse.addListener "data", (data) ->
			body += data

		userscriptsResponse.addListener "end", ->
			response.writeHead 200, "Content-Type" : "text/plain"
			response.end body

	request.end()


server = http.createServer (request, response) ->
	request.addListener "end", ->
		apiPath = "/server/userscripts/"
		path = url.parse(request.url).path
		console.log path
		if path.indexOf(apiPath) is 0
			userscriptId = path.substr apiPath.length
			load_userscript request, response, userscriptId
		else
			load_static_file(request, response)

server.listen port

console.log "Server running at http://localhost:#{port}/"
