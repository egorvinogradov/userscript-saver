taistiesStorage = new TaistiesStorage();
pageTaistier = new CentralPageTaistier();
function taistTabUp(tab) {
	var taistiesForUrl = taistiesStorage.getTaistiesForUrl(tab.url);
	pageTaistier.TaistTabUp(taistiesForUrl, tab.id);
}

// listening to requests
chrome.extension.onRequest.addListener(function(request, sender, sendResponse) {
	taistTabUp(sender.tab);

	sendResponse({});
})
