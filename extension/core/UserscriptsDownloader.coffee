class UserscriptsDownloader
	@_searchUrlTemplate: 'http://tai.st/server/taisties/%siteName%'

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
			@_ajaxProvider.getUrlContent searchUrl, (userscripts) =>
				allUserscriptsArray = JSON.parse userscripts
				callback (allUserscriptsArray.slice 0, UserscriptsDownloader._maxUserscriptsCount)

	_getSiteNameByUrl: (url) ->
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

	_isValidUserscriptsUrl: (url) -> url.indexOf('http') is 0 or url.indexOf('://') is -1
