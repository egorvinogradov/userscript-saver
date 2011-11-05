class TabTaister
	constructor: ->
		@_tabApi = null
		@_dTaistieCombiner = null
		@_dTaistiesStorage = null
		@_popupResourcePaths = null

	startListeningToTabChange: ->
		@_tabApi.onTabUrlChanged (tabUrl, tabDescriptor) =>
			@updatePopup tabUrl
			@_taistTab tabUrl, tabDescriptor

		@_tabApi.onTabSelected (tabUrl) =>
				@updatePopup tabUrl


	_taistTab: (tabUrl, tabDescriptor) ->
		allTaistiesCssAndJs = @_dTaistieCombiner.getAllCssAndJsForUrl tabUrl
		if not allTaistiesCssAndJs?
			return

		insertedJs = @_dTaistieWrapper.wrapTaistiesCodeToJs allTaistiesCssAndJs

		storage = new LocalStorage
		taistiesEnabled = storage.get 'taistieEnabled'

		if taistiesEnabled and insertedJs isnt null
			@_tabApi.insertJsToTab insertedJs, tabDescriptor
	
	updatePopup: (tabUrl) ->
		existTaisties = @_dTaistieCombiner.existTaistiesForUrl(tabUrl)
		popupResourcePaths = @_popupResourcePaths[if existTaisties then 'enabled' else 'disabled']

		@_tabApi.setIcon popupResourcePaths.icon
		@_tabApi.setPopup popupResourcePaths.page

	
