path = require "path"

taistiePartNames = ['id', 'name', 'description', 'js', 'css']
taistiesFolder = './server/taisties'

module.exports = loadTaistie =  (fs, siteName, callbacks) ->
	taistie =
		rootUrl: siteName

	for partName in taistiePartNames
		do (partName) ->
			getTaistiePartForSiteName fs, siteName, partName,
				success: (partContent) ->
					taistie[partName] = partContent.replace /\s+$/, ''
					if taistieIsCompletelyLoaded taistie
						callbacks.success taistie
				error: ->
					callbacks.error new Error "Taistie for #{siteName} not found"

getTaistiePartForSiteName = (fs, siteName, taistiePartName, callbacks) ->
	partFileName = siteName + '.' + taistiePartName
	filePath = path.join  taistiesFolder, partFileName
	fs.exists filePath, (exists) ->
		if exists
			fs.readFile filePath, (error, fileContent) ->
				callbacks.success fileContent.toString()
		else
			callbacks.error()

taistieIsCompletelyLoaded = (taistie) ->
	unloadedParts = (partName for partName in taistiePartNames when not (partName of taistie))
	return unloadedParts.length is 0

