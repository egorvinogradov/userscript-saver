InsertDownloader = ->

	downloaderUrl = 'http://127.0.0.1:3000/server/downloader.js'

	bindTabUpdate = (callback) ->
		chrome.tabs.onUpdated.addListener (tabId, changeInfo, tab) ->
			if changeInfo.status is 'complete'
				callback tabId, tab.url

	insertJS = (tabId, path) ->
		code = '(' + appendDownloader.toString() + '(\'' + path + '\'))'
		chrome.tabs.executeScript tabId, { code: code }, ->
			console.log 'Taist extension: insert JS', tabId, path

	appendDownloader = (path) ->
		script = document.createElement 'script'
		script.type = 'text/javascript'
		script.src = path
		document.body.appendChild script
		console.log 'Taist initialization', path

	console.log 'Taist extension: init'
	bindTabUpdate (tabId, url) ->
		insertJS tabId, downloaderUrl
