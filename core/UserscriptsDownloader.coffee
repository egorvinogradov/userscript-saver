class UserscriptsDownloader
	@_searchUrlTemplate: 'http://userscripts.org/scripts/search?q=%siteName%&sort=installs'
	@_scriptBodyUrlTemplate = 'http://www.tai.st/server/userscripts/%scriptId%'

	#TODO: передавать количество юзерскриптов как параметр
	@_maxUserscriptsCount = 5

	constructor: ->
		@_ajaxProvider = null

	getUserscriptsForUrl: (url, callback) ->

		searchUrl = UserscriptsDownloader._searchUrlTemplate.replace('%siteName%', @_getSiteNameByUrl url)
		nakedDomain = @_getNakedDomain url
		@_ajaxProvider.getUrlContent searchUrl, (scriptsListPageContent) =>

			scriptRows = scriptsListPageContent.match /tr\sid='scripts-(\d+)'>([\s\S])+?<\/tr>/gm
			scriptRows ?= []

			scripts = []

			scriptsLimit = UserscriptsDownloader._maxUserscriptsCount
			if scriptsLimit > scriptRows.length
				scriptsLimit = scriptRows.length

			getNextRowSerially = (rowIndex) =>
				if rowIndex < scriptsLimit
					@_getScriptFromScriptRow scriptRows[rowIndex], nakedDomain, (script) ->
						scripts.push script
						getNextRowSerially rowIndex + 1
				else
					callback scripts

			getNextRowSerially 0

	_getScriptFromScriptRow: (scriptRow, nakedDomain, callback) ->
		userscript = {}
		userscript.id = parseInt(scriptRow.match(/tr\sid='scripts-(\d+)/)[1])
		userscript.name = scriptRow.match(/<a(?:.)+?>((?:.)+)<\/a>/)[1]
		userscript.description = scriptRow.match(/class='desc'>(([\s\S])*?)<\/p>/)[1]
		userscript.rootUrl = nakedDomain

		userscript.usageCount = parseInt(scriptRow.match(/<td class='inv lp'>(\d+)<\/td>/g)[2].match(/>(\d+)</)[1])

		scriptBodyUrl = UserscriptsDownloader._scriptBodyUrlTemplate.replace('%scriptId%', userscript.id)
		@_ajaxProvider.getUrlContent scriptBodyUrl, (js) ->
			userscript.js = js
			callback userscript

	_getNakedDomain: (url) ->
		urlWithoutProtocol = url.replace /^https?:\/\//, ''

		urlWithoutParams = urlWithoutProtocol
		if urlWithoutParams.indexOf('/') > 0
			match = urlWithoutParams.match /([^\/]+)\//
			urlWithoutParams = match[1]

		domainsString = urlWithoutParams.replace /^www\./, '' # remove 'www.' from beginning - only domains left

		domainsArray = domainsString.split '.'

		rootDomainPosition = if domainsArray.length >= 2 then domainsArray.length - 2 else 0
		nakedDomain = domainsArray.slice(rootDomainPosition).join '.'

		return nakedDomain

	_getSiteNameByUrl: (url) -> @_getNakedDomain(url).split('.')[0]
