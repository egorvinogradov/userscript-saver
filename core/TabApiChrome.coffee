TabApi =
	onTabUrlChanged: (tabTaistCallback) ->
		chrome.tabs.onUpdated.addListener (tabId, changeInfo, tabInfo) ->
			if changeInfo.status is 'complete'
				tabTaistCallback tabInfo.url, tabId

	insertJsToTab: (jsCode, tabDescriptor) ->
		tabId = tabDescriptor
		console.log "inserting code", tabDescriptor, jsCode
		chrome.tabs.executeScript tabId, code: jsCode

	openTab: (url) ->
		chrome.tabs.create url: url

	onTabSelected: (selectedTabCallBack) ->
		chrome.tabs.onSelectionChanged.addListener () ->
			chrome.tabs.getSelected null, (tab) ->
				selectedTabCallBack tab.url

	setIcon: (iconPath) ->
		chrome.browserAction.setIcon
			path: iconPath

	setPopup: (popupPath) ->
		chrome.browserAction.setPopup
			popup: popupPath

