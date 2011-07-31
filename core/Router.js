var Router = (function() {
	function getBundles(url, callBack) {
		var bundles = []

		var routes = JSON.parse(localStorage.getItem('routes'))
		for (var route in routes) {
			var routeRE = new RegExp(route, 'g')
			if (routeRE.test(url)) {
				bundles.push(routes[route])
			}
		}

		callBack(bundles)
	}

	return {
		getBundles: getBundles
	}
})()