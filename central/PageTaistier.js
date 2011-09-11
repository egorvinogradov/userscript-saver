PageTaistier = function() {
}

PageTaistier.prototype.setTaistiesStorage = function(taistiesStorage) {
	this._taistiesStorage = taistiesStorage
}

PageTaistier.prototype.TaistTabUp = function(taistedTab) {

	var taisties = this._getTaistiesForTab(taistedTab)

	taisties.forEach(function(currentTaistie) {

		//js-библиотеки и css нужно вставить до использующего их js-кода
		currentTaistie.getJsLibs().forEach(function(jsLibFileName) {
			taistedTab.insertJsFile(jsLibFileName)
		})

		var insertedCodeTypes = ['Css', 'Js']
		insertedCodeTypes.forEach(function(insertedCodeType) {
			this._insertCodeByType(insertedCodeType, currentTaistie, taistedTab)
		})

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

	var allTaisties = this._taistiesStorage.getAllTaisties()
	var taistiesForUrl = []

	allTaisties.forEach(function(checkedTaistie) {
		if (checkedTaistie.fitsUrl(tabUrl)) {
			taistiesForUrl.push(checkedTaistie)
		}
	})

	return taistiesForUrl
}
