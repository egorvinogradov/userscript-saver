class TabTaister
	#TODO: complete specs
	constructor: ->
		@_tabApi = null
		@_dTaistieCombiner = null
		@_dTaistiesStorage = null
		@_popupIconPaths = null

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

		if not allTaistiesCssAndJs?
			return

		insertedJs = @_dTaistieWrapper.wrapTaistiesCodeToJs allTaistiesCssAndJs
		if insertedJs isnt null
			@_tabApi.insertJsToTab insertedJs, tabDescriptor
	
	updatePopup: (tabUrl) ->
		@_updatePopupInstantly tabUrl

		@_tabApi.getCurrentUrl (url) =>
			Taistie.getTaistiesForUrl url, (taisties) =>
				@_updatePopupInstantly url, taisties

	_updatePopupInstantly: (tabUrl, allTaistiesForUrl) =>
		localTaisties = @_dTaistieCombiner.existLocalTaistiesForUrl tabUrl
		popupIconPath = @_popupIconPaths[if localTaisties then 'enabled' else 'disabled']
		@_tabApi.setIcon popupIconPath

		allTaistiesForUrl ?= []

		#TODO: вынести в логику и покрыть тестами
		recommended = (taistie for taistie in allTaistiesForUrl when taistie.isUserscript() and not taistie.isActive())
		badgeText = if recommended.length > 0 then recommended.length.toString() else ''
		chrome.browserAction.setBadgeText text: badgeText


	refresh: ->
		#workaround to refresh Taisties while developing
		#TODO: incapsulate in Taistie
		Taistie.fetch()
