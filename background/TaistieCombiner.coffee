class TaistieCombiner 

	getAllCssAndJsForUrl: (url) ->
		taisties = @_getActiveTaistiesForUrl url
		if taisties.length == 0 then null
		else
			joinTaistieParts = (partGetter) ->
				(taistie[partGetter]() for taistie in taisties when taistie[partGetter]() != '').join('\n\n')

			js: joinTaistieParts 'getJs'
			css: joinTaistieParts 'getCss'

	_getAllTaistiesForUrl: (url) ->
		assert url? and url != '', 'url should be given'
		taistie for taistie in Taistie.all() when taistie.fitsUrl(url)

	_getActiveTaistiesForUrl: (url) ->
		taistie for taistie in @_getAllTaistiesForUrl(url) when taistie.isActive()

	existTaistiesForUrl: (url) -> @_getAllTaistiesForUrl(url).length > 0
