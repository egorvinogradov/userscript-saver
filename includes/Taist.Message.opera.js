// ==UserScript==
// @include http://*/*
// @include https://*/*
// ==/UserScript==

Taist.Message = (function() {
	var eventListeners = {}

	function incomingDispatcher(evt) {
		var data = evt.data

		var requestType = data.type
		if (requestType in eventListeners) {
			eventListeners[requestType].forEach(function(handler) {
				handler(data)
			})
		}
	}

	this.subscribe = function(eventName, handler) {
		if (!(eventName in eventListeners)) {
			eventListeners[eventName] = []
		}

		eventListeners[eventName].push(handler)
	}

	this.post = function(eventName, eventData) {
		var requestData = {
			type: eventName,
			data: eventData
		}
		opera.extension.postMessage(requestData)
	}

	opera.extension.onmessage = incomingDispatcher

}).call({})