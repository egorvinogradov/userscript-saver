function CentralTaistiesStorage() {}

CentralTaistiesStorage.prototype.getAllTaisties = function () {

	//пока храним все тейсти прямо в коде, затем сделаем хранение на сервере
	var allTaistiesByUrlRegExps = {
	}

	//include locally developed function
	var currentDevelopedTaistie = getDevelopedTaistieData();
	allTaistiesByUrlRegExps[currentDevelopedTaistie.siteRegexp] = currentDevelopedTaistie.contents;

	//сохраним в локальном хранилище - пока просто для демонстрации его работы (используется в options.html)
	localStorage.setItem('routes', JSON.stringify(allTaistiesByUrlRegExps));

	return allTaistiesByUrlRegExps;

};
