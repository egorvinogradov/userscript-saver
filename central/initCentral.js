taistiesStorage = new TaistiesStorage();

function taistTabUp(tab) {
	var taistiesForUrl = taistiesStorage.getTaistiesForUrl(tab.url);
	insertTaistiesToPage(taistiesForUrl, tab.id);
}

// listening to requests
chrome.extension.onRequest.addListener(function(request, sender, sendResponse) {
	taistTabUp(sender.tab);

	sendResponse({});
})
