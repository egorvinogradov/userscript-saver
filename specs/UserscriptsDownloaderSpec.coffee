describe 'UserscriptsDownloader', ->
	searchUrlPrefix = 'http://userscripts.org/scripts/search?q='

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

			for testDescription, testUrl of testUrls
				do(testDescription, testUrl) ->
					it testDescription, ->
						mockAjaxProvider =
							getUrlContent: -> ''
						initDownloader mockAjaxProvider

						spiedMethod = spyOn(mockAjaxProvider, 'getUrlContent').andReturn 'mockContent'

						downloader.getUserscriptsForUrl testUrl
						expect(mockAjaxProvider.getUrlContent).toHaveBeenCalledWith(searchUrlPrefix + 'sitename')

		describe 'gathers all scripts content', ->
			userscripts = null
			beforeEach ->
				initDownloader
					getUrlContent: (url) ->
						getContentFixture()[url]

				userscripts = downloader.getUserscriptsForUrl 'targetSite.com'

			it 'creates a userscript from every row of scripts table', ->
				scriptsInFixtureCount = 2
				expect(userscripts.length).toEqual scriptsInFixtureCount

			it 'gets script id, name and description from ids of rows of scripts table', ->
				expect(userscripts[0]).toEqual {
						id: 55501
						name: 'script1_link_text'
						description: 'script1_description'
						js: 'alert(\'script1\')'
					}

				expect(userscripts[1]).toEqual {
						id: 55502
						name: 'script2_link_text',
						description: "script2_description\n\twith newline"
					}

			getContentFixture = ->
				content = {}
				content['http://userscripts.org/scripts/search?q=targetSite'] = '<tr id="scripts-55501">
					<td class="script-meat">
					<a href="/scripts/show/55502" class="title" title="script1_title">script1_link_text</a>

					<p class="desc">script1_description</p>
					</td>
					<td class="inv lp">
					<b>no&nbsp;reviews</b>
					</td>
					<td class="inv lp">0</td>
					<td class="inv lp">0</td>
					<td class="inv lp">18</td>
					<td class="inv lp">
					<abbr class="updated" title="2012-05-01T08:17:06Z">
					58 minutes ago
					</abbr>
					</td>
					</tr>' +
					'<tr id="scripts-55502">
					<td class="script-meat">
					<a href="/scripts/show/55501" class="title" title="script2_title">script2_link_text</a>

					<p class="desc">script2_description\n\twith newline</p>
					</td>
					<td class="inv lp">
					<b>no&nbsp;reviews</b>
					</td>
					<td class="inv lp">0</td>
					<td class="inv lp">0</td>
					<td class="inv lp">132</td>
					<td class="inv lp">
					<abbr class="updated" title="2012-04-30T15:48:10Z">
					17 hours ago
					</abbr>
					</td>
					</tr>'

				content['http://userscripts.org/scripts/source/55501.user.js'] = 'alert(\'script1\')'

				return content

