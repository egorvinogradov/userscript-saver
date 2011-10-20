describe 'TabTaister', ->
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
		expect(iconPath).toEqual popupResourcePaths.enabled.icon
		expect(pagePath).toEqual popupResourcePaths.enabled.page

		tabTaister.updatePopup urlWithoutTaisties
		expect(iconPath).toEqual popupResourcePaths.disabled.icon
		expect(pagePath).toEqual popupResourcePaths.disabled.page
