(function() {
	var taistiesStorage = new CentralTaistiesStorage();
	var pageTaistier = new CentralPageTaistier();

	//todo: вынести в PageTaistier
	function taistTabUp(tab) {
		var taistiesForUrl = taistiesStorage.getTaistiesForUrl(tab.url);
		pageTaistier.TaistTabUp(taistiesForUrl, tab.id);
	}

	// listening to requests
	chrome.extension.onRequest.addListener(function(request, sender, sendResponse) {
		taistTabUp(sender.tab);

		sendResponse({});
	});
}());
