var TaistiesStorage = (function() {
	function getTaistiesForUrl(url, callBack) {
		var taisties = []

		var allTaistiesByUrlRegexps = this.getAllTaisties();

		for (var route in allTaistiesByUrlRegexps) {
			var routeRE = new RegExp(route, 'g')
			if (routeRE.test(url)) {
				taisties.push(allTaistiesByUrlRegexps[route])
			}
		}

		callBack(taisties)
	}

	function getAllTaisties() {
		var allTaistiesByUrlRegExps = {
			'lenta\\.ru': {
				css: '.hidden { display: none !important }',
				jslib: [],
				js: "var settings = {\n\tpreferred: ['/science/', '/internet/', '/digital/', '/game/']\n}\n\nvar nav = document.querySelector('td.nav')\nvar groups = [].slice.call(nav.querySelectorAll('div.group'), 0)\n\ngroups.forEach(function(group) {\n\tvar links = [].slice.call(group.querySelectorAll('a'), 0)\n\tvar hiddenCount = 0\n\tlinks.forEach(function(link) {\n\t\tvar href = link.getAttribute('href')\n\t\tif (settings.preferred.indexOf(href) == -1) {\n\t\t\tlink.parentNode.className += ' hidden'\n\t\t\thiddenCount++\n\t\t}\n\t})\n\n\tif (hiddenCount == links.length) {\n\t\tgroup.className += ' hidden'\n\t}\n})"
			}
		}

		//сохраним в локальном хранилище - пока просто для демонстрации его работы (используется в options.html)
		localStorage.setItem('routes', JSON.stringify(allTaistiesByUrlRegExps));

		return allTaistiesByUrlRegExps;

	}

	return {
		getTaistiesForUrl: getTaistiesForUrl,
		getAllTaisties: getAllTaisties
	}
})()