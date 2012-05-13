class UserscriptsDownloader
	@_searchUrlTemplate: 'http://userscripts.org/scripts/search?q=%siteName%&sort=installs'
	@_scriptBodyUrlTemplate = 'http://userscripts.org/scripts/source/%scriptId%.user.js'

	constructor: ->
		@_ajaxProvider = null

	getUserscriptsForUrl: (url, callback) ->

		searchUrl = UserscriptsDownloader._searchUrlTemplate.replace('%siteName%', @_getSiteNameByUrl url)
		@_ajaxProvider.getUrlContent searchUrl, (scriptsListPageContent) =>

			scriptRows = scriptsListPageContent.match /tr\sid="scripts-(\d+)">([\s\S])+?<\/tr>/gm

			scripts = []

			getNextRowSerially = (rowIndex) =>
				if rowIndex < scriptRows.length
					@_getScriptFromScriptRow scriptRows[rowIndex], (script) ->
						scripts.push script
						getNextRowSerially rowIndex + 1
				else
					callback scripts

			getNextRowSerially 0

	_getScriptFromScriptRow: (scriptRow, callback) ->
		id = parseInt(scriptRow.match(/tr\sid="scripts-(\d+)/)[1])
		name = scriptRow.match(/<a(?:.)+?>((?:.)+)<\/a>/)[1]
		description = scriptRow.match(/class="desc">(([\s\S])*?)<\/p>/)[1]

		usageCount = parseInt(scriptRow.match(/<td class="inv lp">(\d+)<\/td>/g)[2].match(/>(\d+)</)[1])

		scriptBodyUrl = UserscriptsDownloader._scriptBodyUrlTemplate.replace('%scriptId%', id)
		@_ajaxProvider.getUrlContent scriptBodyUrl, (js) ->
			callback
				id: id, name: name, description: description, js: js, usageCount: usageCount

	_getSiteNameByUrl: (url) ->
		urlWithoutProtocol = url.replace /^https?:\/\//, ''

		urlWithoutParams = urlWithoutProtocol
		if urlWithoutParams.indexOf('/') > 0
			match = urlWithoutParams.match /([^\/]+)\//
			urlWithoutParams = match[1]

		domainsString = urlWithoutParams.replace /^www\./, '' # remove 'www.' from beginning - only domains left

		domainsArray = domainsString.split '.'

		rootDomainPosition = if domainsArray.length >= 2 then domainsArray.length - 2 else 0
		rootDomain = domainsArray[rootDomainPosition]

		siteName = rootDomain

		return siteName
