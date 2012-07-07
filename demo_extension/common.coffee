YouScan =
	config:
	    urlRe: /^(?:http|https):\/\/(?:www\.)?youscan\.(?:ru|biz)/
	    downloader: 'http://www.tai.st/server/downloader.js'
	init: ->
		console.log 'Taist extension: init'
		_this = @
		@bindTabUpdate (tabId, url) ->
		    if _this.config.urlRe.test url
			    _this.insertJS tabId, _this.config.downloader
	bindTabUpdate: (callback) ->
		chrome.tabs.onUpdated.addListener (tabId, changeInfo, tab) ->
			if changeInfo.status is 'complete'
				callback tabId, tab.url
	insertJS: (tabId, path) ->
		code = '(' + @appendDownloader.toString() + '(\'' + path + '\'))'
		chrome.tabs.executeScript tabId, { code: code }, ->
			console.log 'Taist extension: insert JS', tabId, path
	appendDownloader: (path) ->
		script = document.createElement 'script'
		script.type = 'text/javascript'
		script.src = path
		document.body.appendChild script
		console.log 'Taist initialization', path
