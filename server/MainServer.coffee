staticServer = require "node-static"
http = require "http"
url = require "url"
fs = require "fs"
loadTaistie = require "./LoadTaistie"

webroot = './server/public'
port = process.env.PORT || 3000

fileServer = new(staticServer.Server) webroot, cache: 600

loadStaticFile = (request, response) ->
	fileServer.serve request, response, (error, result) ->
		if error
			console.error 'Error serving %s - %s', request.url, error.message
			response.writeHead error.status, error.headers
			response.end 'Error: ' + error.status


server = http.createServer (request, response) ->
	request.addListener "end", ->
		apiPath = "/server/taisties/"
		requestPath = url.parse(request.url).path

		if requestPath.indexOf(apiPath) is 0
			siteName = requestPath.substr apiPath.length

			loadTaistieSuccess = (taistie) ->
				response.writeHead 200, "Content-Type" : "text/plain"
				response.end  'Taist.applyTaisties(' + (JSON.stringify [taistie]) + ');'

			loadTaistieError = (error) ->
				console.error 'Error calling loadTaistie: %s - %s', request.url, error.message
				response.writeHead 404, "Content-Type" : "text/plain"
				response.end 'Error: taistie not found'

			loadTaistie fs, siteName,
				success: loadTaistieSuccess
				error: loadTaistieError
		else
			loadStaticFile(request, response)

server.listen port

console.log "Server running at http://localhost:#{port}/"
