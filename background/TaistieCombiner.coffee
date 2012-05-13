class TaistieCombiner
	constructor: ->
		@_taistieCollection = null

	getAllCssAndJsForUrl: (url) ->
		taisties = @_taistieCollection.getActiveTaistiesForUrl url

		if taisties.length == 0 then null
		else
			joinTaistieParts = (partGetter) ->
				(taistie[partGetter]() for taistie in taisties when taistie[partGetter]() != '').join('\n\n')

			js: joinTaistieParts 'getJs'
			css: joinTaistieParts 'getCss'

	_getAllTaistiesForUrl: (url) ->
		@_taistieCollection.getTaistiesForUrl url

	existTaistiesForUrl: (url) -> @_getAllTaistiesForUrl(url).length > 0
