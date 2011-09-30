TabApi = {
	subscribeToTabChange: function(tabTaistCallback) {
		chrome.tabs.onUpdated.addListener(function(tabId, changeInfo, tabInfo) {
			if (changeInfo.status == 'complete') {
				tabTaistCallback(tabInfo.url, tabId)
			}
		})
	},

	insertJsToTab: function(jsCode, tabDescriptor) {
		var tabId = tabDescriptor
		chrome.tabs.executeScript(tabId, {code: jsCode})
	}
}