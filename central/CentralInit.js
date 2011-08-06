(function() {
	var taistiesStorage = new CentralTaistiesStorage();
	var pageTaistier = new CentralPageTaister();

	//todo: вынести в PageTaistier
	function taistTabUp(tabInfo) {
		var taistiesForUrl = taistiesStorage.getTaistiesForUrl(tabInfo.url);
		pageTaistier.TaistTabUp(taistiesForUrl, tabInfo.id);
	}

	// listening to requests
	chrome.tabs.onUpdated.addListener(function(tabId, changeInfo, Info) {
		if(changeInfo.status == 'complete') {
			taistTabUp(Info);
		}
	});
}());
