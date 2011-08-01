var TaistiesStorage = (function() {
	function getTaistiesForUrl(url, callBack) {
		var taisties = []

		//TODO: move to separate method getAllTaisties
		var routes = {
			'lenta\\.ru': {
				css: '.hidden { display: none !important }',
				jslib: [],
				js: "var settings = {\n\tpreferred: ['/science/', '/internet/', '/digital/', '/game/']\n}\n\nvar nav = document.querySelector('td.nav')\nvar groups = [].slice.call(nav.querySelectorAll('div.group'), 0)\n\ngroups.forEach(function(group) {\n\tvar links = [].slice.call(group.querySelectorAll('a'), 0)\n\tvar hiddenCount = 0\n\tlinks.forEach(function(link) {\n\t\tvar href = link.getAttribute('href')\n\t\tif (settings.preferred.indexOf(href) == -1) {\n\t\t\tlink.parentNode.className += ' hidden'\n\t\t\thiddenCount++\n\t\t}\n\t})\n\n\tif (hiddenCount == links.length) {\n\t\tgroup.className += ' hidden'\n\t}\n})"
			}
		}
		localStorage.setItem('routes', JSON.stringify(routes))

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
