Taist.Message = (function() {
	var eventListeners = {}

	function incomingDispatcher(request, sender, callback) {
		var requestType = request.type
		if (requestType in eventListeners) {
			eventListeners[requestType].forEach(function(handler) {
				handler(request)
			})
		}

		callback() // closing connections is a good manner
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
		chrome.extension.sendRequest(requestData)
	}

	chrome.extension.onRequest.addListener(incomingDispatcher)

}).call({})