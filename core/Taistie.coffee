class Taistie
	setTaistieData: (taistieData) ->
		assert !!taistieData.urlRegexp, 'url regexp shoul be given'

		@_urlRegexp = taistieData.urlRegexp
		@_js = taistieData.js ? ''
		@_css = taistieData.css ? '' 

	fitsUrl: (url) ->
		urlRegexp = new RegExp(@_urlRegexp, 'g')
		return urlRegexp.test(url)

	getCss: () ->
		return @_css

	getJs: () ->
		return @_js is '' ? '' : '(function(){' + @_js + '})();'
