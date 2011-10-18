class TabTaister

	startListeningToTabChange: ->
		@_tabApi.subscribeToTabChange (tabUrl, tabDescriptor) =>
			@_taistTab tabUrl, tabDescriptor

		chrome.tabs.onSelectionChanged.addListener () =>
			chrome.tabs.getSelected null, (tab) =>
				@_setIcon tab.url


	_taistTab: (tabUrl, tabDescriptor) ->
		@_setIcon tabUrl
		allTaistiesCssAndJs = @_dTaistieCombiner.getAllCssAndJsForUrl tabUrl
		insertedJs = @_dTaistieWrapper.wrapTaistiesCodeToJs allTaistiesCssAndJs

		if insertedJs isnt null
			@_tabApi.insertJsToTab insertedJs, tabDescriptor
	
	_setIcon: (tabUrl) ->
		existTaisties = @_dTaistieCombiner.existTaistiesForUrl(tabUrl)
		chrome.browserAction.setIcon
		      path: '../icons/browser_action_taistie_' + (if existTaisties then 'enabled' else 'disabled') + '.png'
