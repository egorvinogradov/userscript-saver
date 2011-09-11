(function() {
	var taistiesStorage = new TaistiesStorage()
	var pageTaistier = new PageTaistier()

	pageTaistier.setTaistiesStorage(taistiesStorage)

	// listening to requests
	chrome.tabs.onUpdated.addListener(function(tabId, changeInfo, tabInfo) {
		if(changeInfo.status == 'complete') {
			pageTaistier.TaistTabUp(new TabChrome(tabId, tabInfo.url))
		}
	})
}())
