util = require "util"
http = require "http"
url = require "url"
path = require "path"
fs = require "fs"
events = require "events"

load_static_file = (uri, response) ->
	if uri is '/'
		uri = '/index.html'
	filename = path.join process.cwd(), '/promo/public', uri
	path.exists filename, (exists) ->
		if not exists
			response.writeHead 404, {"Content-Type": "text/plain"}
			response.end "404 Not Found\n"

		else fs.readFile filename, "binary", (err, file) ->
			if err
				response.writeHead 500, {"Content-Type": "text/plain"}
				response.end err + "\n"
			else
				response.statusCode = 200
				response.end file, "binary"

port = process.env.PORT || 3000
server = http.createServer (request, response) ->
	uri = url.parse(request.url).pathname

	if uri is "/server"
		#add logic here
		return
	else
		load_static_file(uri, response)

server.listen port

util.puts "Server running at http://localhost:#{port}/"
