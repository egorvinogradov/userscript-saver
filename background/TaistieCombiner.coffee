class TaistieCombiner
	constructor: ->
		@_taistieCollection = null

	getAllCssAndJsForUrl: (url) ->
		taisties = @_taistieCollection.getActiveTaistiesForUrl url

		if taisties.length == 0 then null
		else
			joinTaistieParts = (partGetter) ->
				taistieParts = (taistie[partGetter]() for taistie in taisties when taistie[partGetter]() != '')
				taistieParts.join '\n\n'

			js: joinTaistieParts 'getJs'
			css: joinTaistieParts 'getCss'

	existLocalTaistiesForUrl: (url) -> @_taistieCollection.getLocalTaistiesForUrl(url).length > 0
