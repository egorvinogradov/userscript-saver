class TaistieCombiner 

	getAllCssAndJsForUrl: (url) ->
		taisties = @_getTaistiesForUrl url
		allCssString = ''
		allJsString = ''
	
		for currentTaistie in taisties
			do (currentTaistie) ->
				#css вставляем до использующего их js-кода
				if allCssString.length > 0
					allCssString += '\n\n'
				allCssString += currentTaistie.getCss()
				allJsString += currentTaistie.getJs()

		joinTaistieTexts = (textGetter) -> (
			taistie[textGetter]() for taistie in taisties when taistie[textGetter]() != '').join('\n\n')
	
		return js: joinTaistieTexts('getJs'), css: joinTaistieTexts('getCss')
	
	_getTaistiesForUrl: (url) ->
		assert url? and url != '', 'url should be given'
		taistiesForUrl = []
		allTaisties = @_dTaistiesStorage.getAllTaisties()

		for checkedTaistie in allTaisties
			do (checkedTaistie) ->
				if checkedTaistie.fitsUrl(url) and checkedTaistie.isActive()
					taistiesForUrl.push checkedTaistie
		return taistiesForUrl

	existTaistiesForUrl: (url) -> @_getTaistiesForUrl(url).length > 0
