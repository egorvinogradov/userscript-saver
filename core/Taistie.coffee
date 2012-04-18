class Taistie extends Spine.Model
	@_userscriptsDownloader = null

	@configure "Taistie", "name", "active", "urlRegexp", "css", "js"

	@extend Spine.Model.Local

	fitsUrl: (url) ->
		urlRegexp = new RegExp(@urlRegexp, 'g')
		return urlRegexp.test(url)

	getCss: ->
		@css ? ''

	getJs: ->
		if (@js ? '') is '' then '' else '(function(){' + @js + '})();'

	getName: ->
		@name
	isActive: ->
		@active

	@getTaistiesForUrl: (url) ->
		assert url? and url != '', 'url should be given'
		existingTaisties = @select (taistie) -> taistie.fitsUrl url
		userscripts = @_userscriptsDownloader.getUserscriptsForUrl url
		taistiesFromUserScripts = []
		for userscript in userscripts
			do (userscript) ->
				taistie = Taistie.create userscript
				taistiesFromUserScripts.push taistie

		existingTaisties.concat taistiesFromUserScripts
