function req_dispatcher(request, sender, callback) {
	if (request.action == 'bundleReady') {
		Taist.Embed[request.type](document, request.body)
	}

	callback({})
}
chrome.extension.onRequest.addListener(req_dispatcher);

chrome.extension.sendRequest({action: 'getBundles', url: document.location.href})
