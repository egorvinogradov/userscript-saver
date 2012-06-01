class UserscriptsDownloader
	@_searchUrlTemplate: 'http://userscripts.org/scripts/search?q=%siteName%&sort=installs'
	@_scriptBodyUrlTemplate = 'http://www.tai.st/server/userscripts/%scriptId%'

	#TODO: передавать количество юзерскриптов как параметр
	@_maxUserscriptsCount = 5

	constructor: ->
		@_ajaxProvider = null

	getUserscriptsForUrl: (url, callback) ->

		if not @_isValidUserscriptsUrl url
			callback []

		else
			siteName = @_getSiteNameByUrl url
			searchUrl = UserscriptsDownloader._searchUrlTemplate.replace('%siteName%', siteName)
			nakedDomain = @_getNakedDomain url
			@_ajaxProvider.getUrlContent searchUrl, (scriptsListPageContent) =>

				scriptRows = scriptsListPageContent.match /tr\sid='scripts-(\d+)'>([\s\S])+?<\/tr>/gm
				scriptRows ?= []

				scripts = []

				#TODO: добавить тесты на отсечение левых сайтов
				checkJsRegexp = new RegExp "(\\s*)@include(\\s+)(?:.+?)#{siteName}", 'i'
				getNextRowSerially = (rowIndex, scriptsCount) =>
					if rowIndex < scriptRows.length and scriptsCount < UserscriptsDownloader._maxUserscriptsCount
						@_getScriptFromScriptRow scriptRows[rowIndex], nakedDomain, (script) ->
							nextScriptsCount = undefined
							if checkJsRegexp.test script.js
								scripts.push script
								nextScriptsCount = scriptsCount + 1
							else
								nextScriptsCount = scriptsCount
							getNextRowSerially rowIndex + 1, nextScriptsCount
					else
						callback scripts

				getNextRowSerially 0, 0

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

	_isValidUserscriptsUrl: (url) -> url.indexOf('http') is 0 or url.indexOf('://') is -1
