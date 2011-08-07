function CentralTaistiesStorage() {}

CentralTaistiesStorage.prototype.getTaistiesForUrl = function(url) {
	var taistiesForUrl = [];

	var allTaistiesByUrlRegexps = this.getAllTaisties();

	//TODO: вынести проверку url в taistie
	for (var currentTaistieUrlRegexpString in allTaistiesByUrlRegexps) {
		var currentTaistieUrlRegexp = new RegExp(currentTaistieUrlRegexpString, 'g');
		if (currentTaistieUrlRegexp.test(url)) {
			taistiesForUrl.push(allTaistiesByUrlRegexps[currentTaistieUrlRegexpString])
		}
	}

	return taistiesForUrl;
};

CentralTaistiesStorage.prototype.getAllTaisties = function () {
	//пока храним все тейсти прямо в коде, затем сделаем хранение на сервере
	var allTaistiesByUrlRegExps = {
		'lenta\\.ru': {
			css: '.hidden { display: none !important }',
			jslib: [],
			js: "var settings = {\n\tpreferred: ['/science/', '/internet/', '/digital/', '/game/']\n}\n\nvar nav = document.querySelector('td.nav')\nvar groups = [].slice.call(nav.querySelectorAll('div.group'), 0)\n\ngroups.forEach(function(group) {\n\tvar links = [].slice.call(group.querySelectorAll('a'), 0)\n\tvar hiddenCount = 0\n\tlinks.forEach(function(link) {\n\t\tvar href = link.getAttribute('href')\n\t\tif (settings.preferred.indexOf(href) == -1) {\n\t\t\tlink.parentNode.className += ' hidden'\n\t\t\thiddenCount++\n\t\t}\n\t})\n\n\tif (hiddenCount == links.length) {\n\t\tgroup.className += ' hidden'\n\t}\n})"
		}
	};

	//include locally developed function
	var currentDevelopedTaistie = DevelopedTaistie();
	allTaistiesByUrlRegExps[currentDevelopedTaistie.siteRegexp] = currentDevelopedTaistie.contents;

	//сохраним в локальном хранилище - пока просто для демонстрации его работы (используется в options.html)
	localStorage.setItem('routes', JSON.stringify(allTaistiesByUrlRegExps));

	return allTaistiesByUrlRegExps;

};
