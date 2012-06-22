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

			cssAndJs =
				js: joinTaistieParts 'getJsForInsertion'
				css: joinTaistieParts 'getCss'

			return cssAndJs

	existLocalTaistiesForUrl: (url) -> @_taistieCollection.getCachedTaistiesForUrl(url).length > 0
