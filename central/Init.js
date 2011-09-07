(function() {
	var taistiesStorage = new CentralTaistiesStorage();
	var pageTaistier = new CentralPageTaistier();

	pageTaistier.setTaistiesStorage(taistiesStorage);

	// listening to requests
	chrome.tabs.onUpdated.addListener(function(tabId, changeInfo, Info) {
		if(changeInfo.status == 'complete') {
			pageTaistier.TaistTabUp(Info.url, tabId);
		}
	});
}());
