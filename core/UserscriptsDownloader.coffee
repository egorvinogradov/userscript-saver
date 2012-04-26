class UserscriptsDownloader
	@_userscriptsSearchPrefix: 'http://userscripts.org/scripts/search?q='
	constructor: ->
		@_ajaxProvider = null

	getUserscriptsForUrl: (url) ->

		siteName = url
		siteName = siteName.replace /^https?:\/\//, ''    # remove 'http://' and 'https://' from beginning

		if siteName.indexOf('/') > 0
			match = siteName.match /([^\/]+)\//          # remove all after '/'
			siteName = match[1]

		siteName = siteName.replace /^www\./, '' # remove 'www.' from beginning - only domains left

		siteName = siteName.replace /\.[A-Z]+$/i, '' #remove last domain

		@_ajaxProvider.getUrlContent(UserscriptsDownloader._userscriptsSearchPrefix + siteName)
		return []
