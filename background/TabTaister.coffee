class TabTaister

	startListeningToTabChange: ->
		@_tabApi.subscribeToTabChange (tabUrl, tabDescriptor) =>
			@_taistTab tabUrl, tabDescriptor

	_taistTab: (tabUrl, tabDescriptor) ->
		allTaistiesCssAndJs = @_dTaistieCombiner.getAllCssAndJsForUrl tabUrl
		insertedJs = @_dTaistieWrapper.wrapTaistiesCodeToJs allTaistiesCssAndJs

		if insertedJs isnt null
			@_tabApi.insertJsToTab insertedJs, tabDescriptor
	
	
