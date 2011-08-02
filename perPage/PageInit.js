(function() {
	var taistieEmbedder = new PageTaistiePartEmbedder();

	//noinspection JSUnusedLocalSymbols
	function req_dispatcher(request, unusedSender, callback) {
		if (request.action == 'bundleReady') {
			taistieEmbedder.embedTaistie(document, request.type, request.body)
		}

		callback({});
	}

	chrome.extension.onRequest.addListener(req_dispatcher);

	chrome.extension.sendRequest({action: 'getTaisties', url: document.location.href});
}());
