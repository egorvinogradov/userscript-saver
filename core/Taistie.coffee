class Taistie extends Spine.Model
	#TODO: убрать поле "done"
	@configure "Taistie", "name", "active", "urlRegexp", "css", "js"

	@extend Spine.Model.Local

	@active: ->
		@select (item) -> !item.done

	@destroyDone: ->
		rec.destroy() for rec in @done()

	setTaistieData: (taistieData) ->
		#TODO: написать спеки
		assert taistieData?, 'taistie data should be given'
		assert taistieData.urlRegexp?, 'url regexp shoul be given'

		@urlRegexp = taistieData.urlRegexp
		@js = taistieData.js ? ''
		@css = taistieData.css ? ''
		#TODO: проверять, что имя задано
		@name = taistieData.name
		@active = taistieData.active

	fitsUrl: (url) ->
		urlRegexp = new RegExp(@urlRegexp, 'g')
		return urlRegexp.test(url)

	getCss: () ->
		@css

	getJs: () ->
		if @js is '' then '' else '(function(){' + @js + '})();'

	getName: () ->
		@name

	isActive: () ->
		@active
