class UserscriptsDownloader
	@_userscriptsSearchPrefix: 'http://userscripts.org/scripts/search?q='
	constructor: ->
		@_ajaxProvider = null

	getUserscriptsForUrl: (url) ->

		siteName = @_getSiteNameByUrl url

		scriptsListPageContent = @_ajaxProvider.getUrlContent(UserscriptsDownloader._userscriptsSearchPrefix + siteName)

		scriptRows = scriptsListPageContent.match /tr\sid="scripts-(\d+)">([\s\S])+?<\/td>/gm

		scripts = []

		if scriptRows?
			scripts.push @_getScriptFromScriptRow scriptRow for scriptRow in scriptRows

		return scripts

	_getScriptFromScriptRow: (scriptRow) ->
		id = parseInt(scriptRow.match(/tr\sid="scripts-(\d+)/)[1])
		name = scriptRow.match(/<a(?:.)+?>((?:.)+)<\/a>/)[1]
		description = scriptRow.match(/class="desc">(([\s\S])*?)<\/p>/)[1]

		return id: id, name: name, description: description

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
