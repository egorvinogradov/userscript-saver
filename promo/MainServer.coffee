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

load_remote_taistie = (request, response, remoteTaistieId) ->
	taistiesClient = http.createClient 80, "taisties.org"

	remoteTaistieUri = "/scripts/source/#{remoteTaistieId}.user.js"
	request = taistiesClient.request "GET", remoteTaistieUri, "host": "taisties.org"

	request.addListener "response", (taistiesResponse) ->
		body = ""
		taistiesResponse.addListener "data", (data) ->
			body += data

		taistiesResponse.addListener "end", ->
			response.writeHead 200, "Content-Type" : "text/plain"
			response.end body

	request.end()


server = http.createServer (request, response) ->
	request.addListener "end", ->
		apiPath = "/server/taisties/"
		path = url.parse(request.url).path
		console.log path
		if path.indexOf(apiPath) is 0
			remoteTaistieId = path.substr apiPath.length
			load_remote_taistie request, response, remoteTaistieId
		else
			load_static_file(request, response)

server.listen port

console.log "Server running at http://localhost:#{port}/"
