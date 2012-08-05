path = require "path"
fs = require "fs"

taistiePartNames = ['id', 'name', 'description', 'js', 'css']
taistiesFolder = './server/taisties'

#module.exports = loadTaistie =  (request, response, siteName) ->
module.exports = loadTaistie =  (siteName, callback) ->
	taistie =
		rootUrl: siteName

	for partName in taistiePartNames
		do (partName) ->
			getTaistiePartForSiteName siteName, partName, (partContent) ->
				taistie[partName] = partContent.replace /\s+$/, ''
				if taistieIsCompletelyLoaded taistie
					callback taistie

getTaistiePartForSiteName = (siteName, taistiePartName, callback) ->
	partFileName = siteName + '.' + taistiePartName
	filePath = path.join  taistiesFolder, partFileName
	fs.exists filePath, (exists) ->
		if exists
			fs.readFile filePath, (error, fileContent) ->
				callback fileContent.toString()

taistieIsCompletelyLoaded = (taistie) ->
	unloadedParts = (partName for partName in taistiePartNames when not (partName of taistie))
	return unloadedParts.length is 0

