class Taistie
	setTaistieData: (taistieData) ->
		assert !!taistieData.urlRegexp, 'url regexp shoul be given'

		@_urlRegexp = taistieData.urlRegexp
		@_js = taistieData.js ? ''
		@_css = taistieData.css ? ''
		#TODO: проверять, что имя задано
		@_name = taistieData.name
		@_active = taistieData.active

	fitsUrl: (url) ->
		urlRegexp = new RegExp(@_urlRegexp, 'g')
		return urlRegexp.test(url)

	getCss: () ->
		@_css

	getJs: () ->
		if @_js is '' then '' else '(function(){' + @_js + '})();'

	getName: () ->
		@_name

	isActive: () ->
		@_active
