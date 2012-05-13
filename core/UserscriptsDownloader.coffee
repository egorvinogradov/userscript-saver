class UserscriptsDownloader
	@_searchUrlTemplate: 'http://userscripts.org/scripts/search?q=%siteName%&sort=installs'
	@_scriptBodyUrlTemplate = 'http://userscripts.org/scripts/source/%scriptId%.user.js'

	constructor: ->
		@_ajaxProvider = null

	getUserscriptsForUrl: (url) ->

		searchUrl = UserscriptsDownloader._searchUrlTemplate.replace('%siteName%', @_getSiteNameByUrl url)
		scriptsListPageContent = @_ajaxProvider.getUrlContent searchUrl

		scriptRows = scriptsListPageContent.match /tr\sid="scripts-(\d+)">([\s\S])+?<\/tr>/gm

		scripts = []

		if scriptRows?
			scripts.push @_getScriptFromScriptRow scriptRow for scriptRow in scriptRows

		return scripts

	_getScriptFromScriptRow: (scriptRow) ->
		id = parseInt(scriptRow.match(/tr\sid="scripts-(\d+)/)[1])
		name = scriptRow.match(/<a(?:.)+?>((?:.)+)<\/a>/)[1]
		description = scriptRow.match(/class="desc">(([\s\S])*?)<\/p>/)[1]

		usageCount = parseInt(scriptRow.match(/<td class="inv lp">(\d+)<\/td>/g)[2].match(/>(\d+)</)[1])

		scriptBodyUrl = UserscriptsDownloader._scriptBodyUrlTemplate.replace('%scriptId%', id)
		js = @_ajaxProvider.getUrlContent scriptBodyUrl

		return id: id, name: name, description: description, js: js, usageCount: usageCount

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
