describe 'TabTaister', ->
	mockTabApi = null
	tabTaister = null

	beforeEach ->
		mockTabApi =
			onTabUrlChanged: (handler) ->
				@tabUrlChangeHandler = handler
			onTabSelected: (handler) ->
				@selectedTabChangeHandler = handler
			setIcon: (path) ->
				@iconPath = path
			setPopup: (path) ->
				@pagePath = path
			setBadgeText: (text) ->
				@badgeText = text

		tabTaister = new TabTaister
		tabTaister._tabApi = mockTabApi
		tabTaister.startListeningToTabChange()


	it 'subscribes to selected tab change and its url change', ->
		expect(mockTabApi.selectedTabChangeHandler).toBeDefined()
		expect(mockTabApi.tabUrlChangeHandler).toBeDefined()

	it 'updates popup by @updatePopup on selected tab change according to tab url', ->
		updatedPopupUrl = null

		tabTaister.updatePopup = (url) ->
			updatedPopupUrl = url

		mockTabApi.selectedTabChangeHandler 'new-url.com'
		expect(updatedPopupUrl).toEqual 'new-url.com'

	it 'sets icon and popup depending on whether any taisties fit to current page', ->
		checkedUrl  = null

		urlWithTaisties = 'haveTaisties.com'
		urlWithoutTaisties = 'noTaisties.com'

		popupIconPaths =
			enabled: 'enabledIcon.png'
			disabled: 'disabledIcon.png'

		tabTaister._dTaistieCombiner =
			existLocalTaistiesForUrl: (url) ->
				checkedUrl = url
				return url == urlWithTaisties

		tabTaister._popupIconPaths = popupIconPaths

		tabTaister.updatePopup urlWithTaisties
		expect(checkedUrl).toEqual urlWithTaisties
		expect(mockTabApi.iconPath).toEqual 'enabledIcon.png'

		tabTaister.updatePopup urlWithoutTaisties
		expect(mockTabApi.iconPath).toEqual 'disabledIcon.png'
