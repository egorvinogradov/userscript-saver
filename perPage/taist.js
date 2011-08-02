function req_dispatcher(request, sender, callback) {
	if (request.action == 'bundleReady') {
		Taist.Embed(document, request.type, request.body)
	}

	callback({})
}
chrome.extension.onRequest.addListener(req_dispatcher);

chrome.extension.sendRequest({action: 'getTaisties', url: document.location.href})
