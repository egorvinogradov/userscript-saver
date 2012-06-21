describe 'UserscriptsDownloader', ->

	downloader = null

	initDownloader = (ajaxProvider) ->
		downloader = new UserscriptsDownloader()
		downloader._ajaxProvider = ajaxProvider

	describe 'getUserscriptsForUrl', ->
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

			searchUrl = 'http://userscripts.org/scripts/search?q=sitename&sort=installs'

			expectedUrl = null
			testUrl = (testedUrl) ->
				expectedUrl = undefined
				mockAjaxProvider =
					getUrlContent: (url, callback) -> expectedUrl = url
				initDownloader mockAjaxProvider

				downloader.getUserscriptsForUrl testedUrl, ->

			for testDescription, testedUrl of testUrls
				do(testDescription, testedUrl) ->
					it testDescription, ->
						testUrl testedUrl
						expect(expectedUrl).toEqual(searchUrl)

			it 'doesn\'t process service urls with protocols different from http/https', ->
				testUrl 'chrome://somepath'
				expect(expectedUrl).not.toBeDefined()

		describe 'gathers all scripts content', ->
			userscripts = null
			callAndExpect = (expectFunction) ->
				downloader.getUserscriptsForUrl 'targetSite.com', (results) ->
					userscripts = results
					expectFunction()

			beforeEach ->
				UserscriptsDownloader._maxUserscriptsCount = 5
				initDownloader
					getUrlContent: (url, callback) ->
						callback(getContentFixture()[url])

			it 'creates a userscript from every row of scripts table', ->
				contentFixturesCount = 2
				callAndExpect ->
					expect(userscripts.length).toEqual contentFixturesCount

			it 'gets no more than allowed maximum of userscripts', ->
				UserscriptsDownloader._maxUserscriptsCount = 1
				callAndExpect ->
					expect(userscripts.length).toEqual 1

			it 'gets script id, name and description from ids of rows of scripts table', ->
				callAndExpect ->
					expect(userscripts[0]).toEqual {
							id: 55501
							name: 'script1_link_text'
							description: 'script1_description'
							js: "@include http://targetSite.com\nalert(\'script1\')"
							usageCount: 18
							rootUrl: 'targetSite.com'
						}

					expect(userscripts[1]).toEqual {
							id: 55502
							name: 'script2_link_text',
							description: "script2_description\n\twith newline"
							js: '@include http://targetSite.com\nalert(\'script2\')'
							usageCount: 132
							rootUrl: 'targetSite.com'
						}

			getContentFixture = ->
				content = {}
				content['http://userscripts.org/scripts/search?q=targetSite&sort=installs'] = '<tr id=\'scripts-55501\'>
					<td class=\'script-meat\'>
					<a href=\'/scripts/show/55502\' class=\'title\' title=\'script1_title\'>script1_link_text</a>

					<p class=\'desc\'>script1_description</p>
					</td>
					<td class=\'inv lp\'>
					<b>no&nbsp;reviews</b>
					</td>
					<td class=\'inv lp\'>0</td>
					<td class=\'inv lp\'>0</td>
					<td class=\'inv lp\'>18</td>
					<td class=\'inv lp\'>
					<abbr class=\'updated\' title=\'2012-05-01T08:17:06Z\'>
					58 minutes ago
					</abbr>
					</td>
					</tr>' +
					'<tr id=\'scripts-55502\'>
					<td class=\'script-meat\'>
					<a href=\'/scripts/show/55501\' class=\'title\' title=\'script2_title\'>script2_link_text</a>

					<p class=\'desc\'>script2_description\n\twith newline</p>
					</td>
					<td class=\'inv lp\'>
					<b>no&nbsp;reviews</b>
					</td>
					<td class=\'inv lp\'>0</td>
					<td class=\'inv lp\'>0</td>
					<td class=\'inv lp\'>132</td>
					<td class=\'inv lp\'>
					<abbr class=\'updated\' title=\'2012-04-30T15:48:10Z\'>
					17 hours ago
					</abbr>
					</td>
					</tr>'

				content['http://www.tai.st/server/userscripts/55501'] = "@include http://targetSite.com\nalert(\'script1\')"
				content['http://www.tai.st/server/userscripts/55502'] = '@include http://targetSite.com\nalert(\'script2\')'

				return content

