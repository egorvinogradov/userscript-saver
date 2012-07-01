staticServer = require "node-static"
http = require "http"
url = require "url"
path = require "path"
fs = require "fs"

webroot = './server/public'
taistiesFolder = './server/taisties'
port = process.env.PORT || 3000

fileServer = new(staticServer.Server) webroot, cache: 600

loadStaticFile = (request, response) ->
	fileServer.serve request, response, (error, result) ->
		if error
			console.error 'Error serving %s - %s', request.url, error.message
			response.writeHead error.status, error.headers
			response.end 'Error: ' + error.status

taistiePartNames = ['id', 'name', 'description', 'js', 'css']

loadTaistie = (request, response, siteName) ->

	taistie =
		rootUrl: siteName

	for partName in taistiePartNames
		do (partName) ->
			getTaistiePartForSiteName siteName, partName, (partContent) ->
				taistie[partName] = partContent
				if taistieIsCompletelyLoaded taistie
					sendTaistie taistie, response

getTaistiePartForSiteName = (siteName, taistiePartName, callback) ->
	partFileName = siteName + '.' + taistiePartName
	filePath = path.join  taistiesFolder, partFileName
	path.exists filePath, (exists) ->
		if exists
			fs.readFile filePath, (error, fileContent) -> callback fileContent.toString()

taistieIsCompletelyLoaded = (taistie) ->
	unloadedParts = (partName for partName in taistiePartNames when not (partName of taistie))
	return unloadedParts.length is 0

sendTaistie = (taistie, response) ->
	response.writeHead 200, "Content-Type" : "text/plain"
	response.end  'Taist.applyTaisties(' + (JSON.stringify [taistie]) + ');'

server = http.createServer (request, response) ->
	request.addListener "end", ->
		apiPath = "/server/taisties/"
		requestPath = url.parse(request.url).path

		if requestPath.indexOf(apiPath) is 0
			siteName = requestPath.substr apiPath.length
			loadTaistie request, response, siteName
		else
			loadStaticFile(request, response)

server.listen port

console.log "Server running at http://localhost:#{port}/"
