TabApi =
	subscribeToTabChange: (tabTaistCallback) ->
		chrome.tabs.onUpdated.addListener (tabId, changeInfo, tabInfo) ->
			if changeInfo.status is 'complete'
				tabTaistCallback tabInfo.url, tabId

	insertJsToTab: (jsCode, tabDescriptor) ->
		tabId = tabDescriptor
		chrome.tabs.executeScrip tabId, code: jsCode

	openTab: (url) ->
		chrome.tabs.create url: url

