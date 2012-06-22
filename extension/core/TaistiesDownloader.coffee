class TaistiesDownloader
	@_searchUrlTemplate: 'http://localhost:5000/server/taisties/%siteName%'

	#TODO: передавать количество юзерскриптов как параметр
	@_maxTaistiesCount = 5

	constructor: ->
		@_ajaxProvider = null

	getTaistiesForUrl: (url, callback) ->
		if not @_isValidTargetUrl url
			callback []

		else
			siteName = @_getSiteNameByUrl url
			searchUrl = TaistiesDownloader._searchUrlTemplate.replace('%siteName%', siteName)
			@_ajaxProvider.getUrlContent searchUrl, (taisties) =>
				allTaistiesArray = JSON.parse taisties
				callback (allTaistiesArray.slice 0, TaistiesDownloader._maxTaistiesCount)

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

	_isValidTargetUrl: (url) -> url.indexOf('http') is 0 or url.indexOf('://') is -1
