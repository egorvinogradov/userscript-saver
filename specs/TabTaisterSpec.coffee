describe 'TabTaister', ->
	it 'updates popup by @updatePopup on selected tab change according to tab url', ->
		selectedTabChangeHandler = null
		updatedPopupUrl = null

		tabTaister = new TabTaister
		tabTaister._tabApi =
			onTabUrlChanged: ->
			onTabSelected: (handler) ->
				selectedTabChangeHandler = handler
		tabTaister.updatePopup = (url) ->
			updatedPopupUrl = url

		tabTaister.startListeningToTabChange()
		expect(selectedTabChangeHandler).toBeDefined()
		selectedTabChangeHandler 'new-url.com'
		expect(updatedPopupUrl).toEqual 'new-url.com'

	it 'sets icon and popup depending on whether any taisties fit to current page', ->
		checkedUrl  = null
		iconPath = null
		pagePath = null

		urlWithTaisties = 'haveTaisties.com'
		urlWithoutTaisties = 'noTaisties.com'

		popupResourcePaths =
			enabled:
				icon: 'enabledIcon.png'
				page: 'enabledPage.html'
			disabled:
				icon: 'disabledIcon.png'
				page: 'disabledPage.html'

		tabTaister = new TabTaister
		tabTaister._dTaistieCombiner =
			existTaistiesForUrl: (url) ->
				checkedUrl = url
				return url == urlWithTaisties

		tabTaister._tabApi =
			setIcon: (path) ->
				iconPath = path
			setPopup: (path) ->
				pagePath = path
		tabTaister._popupResourcePaths = popupResourcePaths

		tabTaister.updatePopup urlWithTaisties
		expect(checkedUrl).toEqual urlWithTaisties
		expect(iconPath).toEqual 'enabledIcon.png'
		expect(pagePath).toEqual 'enabledPage.html'

		tabTaister.updatePopup urlWithoutTaisties
		expect(iconPath).toEqual 'disabledIcon.png'
		expect(pagePath).toEqual 'disabledPage.html'
