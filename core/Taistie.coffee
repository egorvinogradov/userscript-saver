class Taistie extends Spine.Model
	#TODO: убрать поле "done"
	@configure "Taistie", "name", "active", "urlRegexp", "css", "js"

	@extend Spine.Model.Local

	@active: ->
		@select (item) -> !item.done

	@destroyDone: ->
		rec.destroy() for rec in @done()

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
