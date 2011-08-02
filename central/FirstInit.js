function taistTabUp(tab) {
	var taistiesForUrl = TaistiesStorage.getTaistiesForUrl(tab.url);
	insertTaistiesToPage(taistiesForUrl, tab.id);
}

// listening to requests
chrome.extension.onRequest.addListener(function(request, sender, sendResponse) {
	taistTabUp(sender.tab);

	sendResponse({});
})
