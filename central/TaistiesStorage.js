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
	}

	//include locally developed function
	var currentDevelopedTaistie = DevelopedTaistie();
	allTaistiesByUrlRegExps[currentDevelopedTaistie.siteRegexp] = currentDevelopedTaistie.contents;

	//сохраним в локальном хранилище - пока просто для демонстрации его работы (используется в options.html)
	localStorage.setItem('routes', JSON.stringify(allTaistiesByUrlRegExps));

	return allTaistiesByUrlRegExps;

};
