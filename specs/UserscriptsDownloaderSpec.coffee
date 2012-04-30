describe 'UserscriptsDownloader', ->
	searchUrlPrefix = 'http://userscripts.org/scripts/search?q='
	userscriptsDownloader = new UserscriptsDownloader()

	xit 'processes all userscripts found for given site', ->
		userscripts = userscriptsDownloader.getUserscriptsForUrl 'http://siteWithThreeScripts.com'
		expect(userscripts.length).toEqual 3

	describe 'searches userscripts by top site name without extension', ->

		testUrls =
			'accepts url without protocol': 'sitename.com'
			'strips \'/\' at the end': 'sitename.com/'
			'accepts url without top-level domain (may be in local network)': 'sitename/'
			'strips http://': 'http://sitename/'
			'strips \'www\'': 'http://www.sitename/'
			'strips secure protocol - https://': 'https://sitename.com/'
			'strips subdomains leaving just root domain': 'http://sub2.sub1.sitename.com/'
			'strips folders and parameters': 'sitename/folder1/folder2/?param1=value1'

		for testDescription, testUrl of testUrls
			do(testDescription, testUrl) ->
				it testDescription, ->
					mockAjaxProvider =
						getUrlContent: ->
					userscriptsDownloader._ajaxProvider = mockAjaxProvider
					spiedMethod = spyOn(mockAjaxProvider, 'getUrlContent')
					userscriptsDownloader.getUserscriptsForUrl testUrl
					expect(mockAjaxProvider.getUrlContent).toHaveBeenCalledWith(searchUrlPrefix + 'sitename')
