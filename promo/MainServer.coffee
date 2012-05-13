static = require "node-static"
util = require "util"
http = require "http"
url = require "url"
path = require "path"
fs = require "fs"
events = require "events"

webroot = './promo/public'
port = process.env.PORT || 3000

fileServer = new(static.Server) webroot, cache: 600

load_static_file = (request, response) ->
	fileServer.serve request, response, (error, result) ->
		if error
			console.error 'Error serving %s - %s', request.url, error.message
			response.writeHead error.status, error.headers
			response.end()

server = http.createServer (request, response) ->
	request.addListener "end", ->
		uri = url.parse(request.url).pathname
		if uri is "/server"
			#add logic here
			return
		else
			load_static_file(request, response)

server.listen port

util.puts "Server running at http://localhost:#{port}/"
