TabApi =
	onTabUrlChanged: (tabTaistCallback) ->
		chrome.tabs.onUpdated.addListener (tabId, changeInfo, tabInfo) ->
			if changeInfo.status is 'complete'
				tabTaistCallback tabInfo.url, tabId

	insertJsToTab: (jsCode, tabDescriptor) ->
		tabId = tabDescriptor
		chrome.tabs.executeScript tabId, code: jsCode

	openTab: (url) ->
		chrome.tabs.create url: url

	onTabSelected: (selectedTabCallBack) ->
		chrome.tabs.onSelectionChanged.addListener () ->
			chrome.tabs.getSelected null, (tab) ->
				selectedTabCallBack tab.url

	getCurrentUrl: (callback) ->
		chrome.windows.getCurrent (win) ->
			chrome.tabs.query {'windowId': win.id, 'active': true}, (arrayOfOneTab) ->
				callback arrayOfOneTab[0].url

	setIcon: (iconPath) ->
		chrome.browserAction.setIcon
			path: iconPath
