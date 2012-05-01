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
					getUrlContent: ->
						getContentFixture()

				userscripts = downloader.getUserscriptsForUrl 'mockUrl'

			it 'creates a userscript from every row of scripts table', ->
				scriptsInFixtureCount = 2
				expect(userscripts.length).toEqual scriptsInFixtureCount

			xit 'gets script ids from ids of rows of scripts table', ->
				userscripts = downloader.getUserscriptsForUrl 'some_url'


			getContentFixture = ->
				'<tr id="scripts-132177">
				<td class="script-meat">
				<a href="/scripts/show/132177" class="title" title="Github.Time.Formatter">Github.Time.Formatter</a>

				<p class="desc">Github.Time.Formatter . I\'m sick of "xx month ago", \'cuz I\'m a programmer, not a goddamn calendar.</p>
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
				'<tr id="scripts-130781">
				<td class="script-meat">
				<a href="/scripts/show/130781" class="title" title="gist raw perm HEAD">gist raw perm HEAD</a>

				<p class="desc">Add permanently HEAD links on Gist. Use for install user.js or load xxx.js with (at)require etc.</p>
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

