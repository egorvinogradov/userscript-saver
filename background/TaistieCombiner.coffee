class TaistieCombiner 

	getAllCssAndJsForUrl: (url) ->
		taisties = @_getTaistiesForUrl url

		joinTaistieParts = (partGetter) ->
			(taistie[partGetter]() for taistie in taisties when taistie[partGetter]() != '').join('\n\n')
	
		js: joinTaistieParts 'getJs'
		css: joinTaistieParts 'getCss'
	
	_getTaistiesForUrl: (url) ->
		assert url? and url != '', 'url should be given'
		taistie for taistie in @_dTaistiesStorage.getAllTaisties() when taistie.fitsUrl(url) and taistie.isActive()

	existTaistiesForUrl: (url) -> @_getTaistiesForUrl(url).length > 0
