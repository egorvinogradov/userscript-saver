class UserscriptsDownloader
	@_userscriptsSearchPrefix: 'http://userscripts.org/scripts/search?q='
	constructor: ->
		@_ajaxProvider = null

	getUserscriptsForUrl: (url) ->

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
		@_ajaxProvider.getUrlContent(UserscriptsDownloader._userscriptsSearchPrefix + siteName)
		return []
