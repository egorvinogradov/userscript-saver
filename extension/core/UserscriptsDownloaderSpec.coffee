describe 'TaistiesDownloader', ->

	downloader = null

	initDownloader = (ajaxProvider) ->
		downloader = new TaistiesDownloader()
		downloader._ajaxProvider = ajaxProvider

	describe 'getTaistiesForUrl', ->
		describe 'searches taisties by site name', ->
			testUrls =
				'accepts url without protocol': 'sitename.com'
				'strips \'/\' at the end': 'sitename.com/'
				'strips http://': 'http://sitename.com/'
				'strips \'www\'': 'http://www.sitename.com/'
				'strips secure protocol - https://': 'https://sitename.com/'
				'strips subdomains leaving just root domain': 'http://sub2.sub1.sitename.com/'
				'strips folders and parameters': 'sitename.com/folder1/folder2/?param1=value1'

			searchUrl = 'http://tai.st/server/taisties/sitename.com'

			expectedUrl = null
			testUrl = (testedUrl) ->
				expectedUrl = undefined
				mockAjaxProvider =
					getUrlContent: (url, callback) -> expectedUrl = url
				initDownloader mockAjaxProvider

				downloader.getTaistiesForUrl testedUrl, ->

			for testDescription, testedUrl of testUrls
				do(testDescription, testedUrl) ->
					it testDescription, ->
						testUrl testedUrl
						expect(expectedUrl).toEqual(searchUrl)

			it 'doesn\'t process service urls with protocols different from http/https', ->
				testUrl 'chrome://somepath'
				expect(expectedUrl).not.toBeDefined()

		describe 'gets all taisties from server', ->
			taistieFixturesCount = 2

			beforeEach ->
				initDownloader
					getUrlContent: (url, callback) ->
						callback(getContentFixture()[url])

			it 'creates a remoteTaistie from every row of scripts table', ->
				largeTaistiesLimit = taistieFixturesCount + 1
				TaistiesDownloader._maxTaistiesCount = largeTaistiesLimit

				downloader.getTaistiesForUrl 'targetSite.com', (taisties) ->
					expect(taisties.length).toEqual taistieFixturesCount
					expect(taisties[0]).toEqual {
							id: 55501
							name: 'script1_link_text'
							description: 'script1_description'
							js: "@include http://targetSite.com\nalert(\'script1\')"
							rootUrl: 'targetSite.com'
						}

					expect(taisties[1]).toEqual {
							id: 55502
							name: 'script2_link_text',
							description: "script2_description\n\twith newline"
							js: '@include http://targetSite.com\nalert(\'script2\')'
							rootUrl: 'targetSite.com'
						}

			it 'gets no more than allowed maximum of taisties', ->
				smallTaistiesLimit = taistieFixturesCount - 1
				TaistiesDownloader._maxTaistiesCount = smallTaistiesLimit
				downloader.getTaistiesForUrl 'targetSite.com', (taisties) ->
					expect(taisties.length).toEqual smallTaistiesLimit

			getContentFixture = ->
				'http://tai.st/server/taisties/targetSite.com': JSON.stringify [
					{
						id: 55501
						name: 'script1_link_text'
						description: 'script1_description'
						js: '@include http://targetSite.com\nalert(\'script1\')'
						rootUrl: 'targetSite.com'
					},
					{
						id: 55502
						name: 'script2_link_text'
						description: 'script2_description\n\twith newline'
						js: '@include http://targetSite.com\nalert(\'script2\')'
						rootUrl: 'targetSite.com'
					}
				]
