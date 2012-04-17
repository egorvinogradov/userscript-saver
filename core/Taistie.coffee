class Taistie extends Spine.Model
	#TODO: убрать поле "done"
	@configure "Taistie", "name", "active", "urlRegexp", "css", "js"

	@extend Spine.Model.Local

	fitsUrl: (url) ->
		urlRegexp = new RegExp(@urlRegexp, 'g')
		return urlRegexp.test(url)

	getCss: () ->
		@css ? ''

	getJs: () ->
		if (@js ? '') is '' then '' else '(function(){' + @js + '})();'

	getName: () ->
		@name

	isActive: () ->
		@active

	@getTaistiesForUrl: (url) ->
		assert url? and url != '', 'url should be given'
		@select (taistie) -> taistie.fitsUrl url
