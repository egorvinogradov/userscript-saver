(function() {
	var taistieEmbedder = new PageTaistiePartEmbedder();

	//noinspection JSUnusedLocalSymbols
	function req_dispatcher(request, unusedSender, callback) {
		if (request.action == 'embedTaistiePart') {
			taistieEmbedder.embedTaistiePart(request.type, request.body)
		}

		callback({});
	}

	chrome.extension.onRequest.addListener(req_dispatcher);

	chrome.extension.sendRequest({action: 'startTaistingUp', url: document.location.href});
}());
