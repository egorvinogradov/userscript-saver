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
		existTaisties = @_dTaistieCombiner.existLocalTaistiesForUrl tabUrl
		popupIconPath = @_popupIconPaths[if existTaisties then 'enabled' else 'disabled']
		callback = (url) ->
			chrome.browserAction.setBadgeText({ text: '' })
			Taistie.getTaistiesForUrl url, (taisties) =>
				if taisties.length then chrome.browserAction.setBadgeText({ text: taisties.length.toString() })
#		@_tabApi.getCurrentUrl callback
		@_tabApi.setIcon popupIconPath

	refresh: ->
		#workaround to refresh Taisties while developing
		#TODO: incapsulate in Taistie
		Taistie.fetch()
