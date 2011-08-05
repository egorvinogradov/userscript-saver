var jsonStore = (function() {
	var storage = window.localStorage

    function put(key, value) {
		storage.setItem(key, JSON.stringify(value))
	}
	function get(key) {
		return JSON.parse(storage.getItem(key))
	}

	return {
		put: put,
		get: get
	}
})();
