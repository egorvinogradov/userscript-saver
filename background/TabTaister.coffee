class TabTaister

	startListeningToTabChange: ->
		@_tabApi.onTabUrlChanged (tabUrl, tabDescriptor) =>
			@_taistTab tabUrl, tabDescriptor

		@_tabApi.onTabSelected (tabUrl) =>
				@_setIcon tabUrl


	_taistTab: (tabUrl, tabDescriptor) ->
		@_setIcon tabUrl
		allTaistiesCssAndJs = @_dTaistieCombiner.getAllCssAndJsForUrl tabUrl
		insertedJs = @_dTaistieWrapper.wrapTaistiesCodeToJs allTaistiesCssAndJs

		storage = new LocalStorage
		taistiesEnabled = storage.get 'taistieEnabled'

		if taistiesEnabled and insertedJs isnt null
			@_tabApi.insertJsToTab insertedJs, tabDescriptor
	
	_setIcon: (tabUrl) ->
		existTaisties = @_dTaistieCombiner.existTaistiesForUrl(tabUrl)
		chrome.browserAction.setIcon
		      path: '../icons/browser_action_taistie_' + (if existTaisties then 'enabled' else 'disabled') + '.png'
		chrome.browserAction.setPopup
			popup: if existTaisties then 'popup/popup.html' else ''
