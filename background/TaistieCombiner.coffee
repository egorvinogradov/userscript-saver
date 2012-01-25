class TaistieCombiner 

	getAllCssAndJsForUrl: (url) ->
		taisties = @_getTaistiesForUrl url
		if taisties.length == 0 then null
		else
			joinTaistieParts = (partGetter) ->
				(taistie[partGetter]() for taistie in taisties when taistie[partGetter]() != '').join('\n\n')

			js: joinTaistieParts 'getJs'
			css: joinTaistieParts 'getCss'
	
	_getTaistiesForUrl: (url) ->
		assert url? and url != '', 'url should be given'
		taistie for taistie in Taistie.all() when taistie.fitsUrl(url) and taistie.isActive()

	existTaistiesForUrl: (url) -> @_getTaistiesForUrl(url).length > 0
