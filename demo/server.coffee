Http = require 'http'
Url = require 'url'
Querystring = require 'querystring'
Mongo = require 'mongodb'
Server = mongo.Server
Db = mongo.Db
Router = require './router'

start = ->
	Http.createServer(serve).listen(8000)
	console.log 'Server created'
#	Router.route


serve = (request, response) ->


exports.server = server;
