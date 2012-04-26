describe 'UserscriptsDownloader', ->
	searchUrlPrefix = 'http://userscripts.org/scripts/search?q='
	userscriptsDownloader = new UserscriptsDownloader()

	xit 'processes all userscripts found for given site', ->
		userscripts = userscriptsDownloader.getUserscriptsForUrl 'http://siteWithThreeScripts.com'
		expect(userscripts.length).toEqual 3

	describe 'searches userscripts by top site name without extension', ->

		testUrls =
			'simple url': 'sitename.com'
			'url with \'/\' at the end': 'sitename.com/'
			'url without top-level domain (may be in local network)': 'sitename/'
			'starting from http://': 'http://sitename/'
			'with www': 'http://www.sitename/'
			'https url': 'https://sitename.com/'
			'url with folders and parameters': 'sitename/folder1/folder2/?param1=value1'

		for testDescription, testUrl of testUrls
			do(testDescription, testUrl) ->
				it testDescription, ->

				mockAjaxProvider =
					getUrlContent: ->
				userscriptsDownloader._ajaxProvider = mockAjaxProvider
				spiedMethod = spyOn(mockAjaxProvider, 'getUrlContent')
				userscriptsDownloader.getUserscriptsForUrl testUrl
				expect(mockAjaxProvider.getUrlContent).toHaveBeenCalledWith(searchUrlPrefix + 'sitename')
