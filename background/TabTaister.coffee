class TabTaister
	#TODO: complete specs
	constructor: ->
		@_tabApi = null
		@_dTaistieCombiner = null
		@_dTaistiesStorage = null
		@_popupResourcePaths = null

	startListeningToTabChange: ->
		@_tabApi.onTabUrlChanged (tabUrl, tabDescriptor) =>
			@refresh()
			@updatePopup tabUrl
			@_taistTab tabUrl, tabDescriptor

		@_tabApi.onTabSelected (tabUrl) =>
			@refresh()
			@updatePopup tabUrl


	_taistTab: (tabUrl, tabDescriptor) ->
		allTaistiesCssAndJs = @_dTaistieCombiner.getAllCssAndJsForUrl tabUrl

		console.log tabUrl, allTaistiesCssAndJs
		if not allTaistiesCssAndJs?
			return

		insertedJs = @_dTaistieWrapper.wrapTaistiesCodeToJs allTaistiesCssAndJs
		if insertedJs isnt null
			@_tabApi.insertJsToTab insertedJs, tabDescriptor
	
	updatePopup: (tabUrl) ->
		existTaisties = @_dTaistieCombiner.existTaistiesForUrl tabUrl
		popupResourcePaths = @_popupResourcePaths[if existTaisties then 'enabled' else 'disabled']

		@_tabApi.setIcon popupResourcePaths.icon
		@_tabApi.setPopup popupResourcePaths.page

	refresh: ->
		#workaround to refresh Taisties while developing
		#TODO: incapsulate in Taistie
		Taistie.fetch()

	
