PageTaistier = function() {
}

PageTaistier.prototype.setTaistiesStorage = function(taistiesStorage) {
	this._taistiesStorage = taistiesStorage
}

PageTaistier.prototype.TaistTabUp = function(taistedTab) {

	var taisties = this._getTaistiesForTab(taistedTab)

	taisties.forEach(function(currentTaistie) {
		//css вставляем до использующего их js-кода
		this._insertCodeByType('Css', currentTaistie, taistedTab)
		this._insertCodeByType('Js', currentTaistie, taistedTab)
	})

}

PageTaistier.prototype._insertCodeByType = function(codeType, currentTaistie, tab) {
	var insertMethodName = 'insert' + codeType
	var code = currentTaistie['get' + codeType]()

	//js и css могут быть пустыми строками - такие просто пропускаем
	if (code.length > 0) {
		tab[insertMethodName](code)
	}
}


PageTaistier.prototype._getTaistiesForTab = function(tab) {
	var tabUrl = tab.getUrl()
	var taistiesForUrl = []
	var allTaisties = this._taistiesStorage.getAllTaisties()

	allTaisties.forEach(function(checkedTaistie) {
		if (checkedTaistie.fitsUrl(tabUrl)) {
			taistiesForUrl.push(checkedTaistie)
		}
	})

	return taistiesForUrl
}
