TaistieCombiner = function() {
}

TaistieCombiner.prototype.setTaistiesStorage = function(taistiesStorage) {
	this._taistiesStorage = taistiesStorage
}

TaistieCombiner.prototype.getAllCssAndJsForUrl = function(url) {
	var taisties = this._getTaistiesForUrl(url)
	var allCssString = ''
	var allJsString = ''

	taisties.forEach(function(currentTaistie) {
		//css вставляем до использующего их js-кода
		allCssString += currentTaistie.getCss()
		allJsString += currentTaistie.getJs()
	})

	return {js: allJsString, css: allCssString}
}

TaistieCombiner.prototype._getTaistiesForUrl = function(url) {
	assert(!!url, 'url should be given')
	var taistiesForUrl = []
	var allTaisties = this._taistiesStorage.getAllTaisties()

	allTaisties.forEach(function(checkedTaistie) {
		if (checkedTaistie.fitsUrl(url)) {
			taistiesForUrl.push(checkedTaistie)
		}
	})

	return taistiesForUrl
}
