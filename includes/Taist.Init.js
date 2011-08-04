// ==UserScript==
// @include http://*/*
// @include https://*/*
// ==/UserScript==

Taist.Init = (function() {
	var taistieEmbedder = new Taist.Embedder(document);

	//noinspection JSUnusedLocalSymbols
	function req_dispatcher(request, unusedSender, callback) {
		if (request.action == 'embedTaistiePart') {
			taistieEmbedder.embedTaistiePart(request.type, request.body)
		}

		callback({});
	}

	chrome.extension.onRequest.addListener(req_dispatcher);

	chrome.extension.sendRequest({action: 'startTaistingUp', url: document.location.href});

	return this
}).call({});
