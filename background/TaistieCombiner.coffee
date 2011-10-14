class TaistieCombiner 

	getAllCssAndJsForUrl: (url) ->
		taisties = @_getTaistiesForUrl url
		allCssString = ''
		allJsString = ''
	
		for currentTaistie in taisties
			do (currentTaistie) ->
				#css вставляем до использующего их js-кода
				allCssString += currentTaistie.getCss()
				allJsString += currentTaistie.getJs()
	
		return js: allJsString, css: allCssString
	
	_getTaistiesForUrl: (url) ->
		assert url? and url != '', 'url should be given'
		taistiesForUrl = []
		allTaisties = @_dTaistiesStorage.getAllTaisties()

		for checkedTaistie in allTaisties
			do (checkedTaistie) ->
				if checkedTaistie.fitsUrl url
					taistiesForUrl.push checkedTaistie

		return taistiesForUrl
