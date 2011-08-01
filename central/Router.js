var TaistiesStorage = (function() {
	function getTaistiesForUrl(url, callBack) {
		var taisties = []

		var routes = JSON.parse(localStorage.getItem('routes'))
		for (var route in routes) {
			var routeRE = new RegExp(route, 'g')
			if (routeRE.test(url)) {
				taisties.push(routes[route])
			}
		}

		callBack(taisties)
	}

	return {
		getTaistiesForUrl: getTaistiesForUrl
	}
})()
