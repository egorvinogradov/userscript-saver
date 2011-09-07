CentralPageTaistier = function() {
}

CentralPageTaistier.prototype.setTaistiesStorage = function(taistiesStorage) {
	this._taistiesStorage = taistiesStorage
}

CentralPageTaistier.prototype.TaistTabUp = function(url, tabId) {

	var taisties = this.getTaistiesForUrl(url)

	var insertionParamsByTaistiePartType = {
		'css': {
			method: 'insertCSS',
			source: 'code'
		},
		'js': {
			method: 'executeScript',
			source: 'code'
		},
		'jslib': {
			method: 'executeScript',
			source: 'file'
		}
	}

	taisties.forEach(function(currentTaistie) {
		var orderedTaistiePartTypes = ['jslib', 'css', 'js']
		orderedTaistiePartTypes.forEach(function(taistiePartType) {
			if (taistiePartType in currentTaistie._contents) {
				_insertTaistiePart(tabId, taistiePartType, currentTaistie._contents[taistiePartType])
			}
		})
	})

	function _insertTaistiePart(taistedTabId, taistiePartType, uncheckedTaistiePartValuesList) {

		//только библиотеки (jslib) содержат список значений, css и js - единичные значения
		//поэтому для простоты все приведем к единому виду - списку
		var taistiePartValuesList = (taistiePartType == 'jslib' ? uncheckedTaistiePartValuesList : [
			uncheckedTaistiePartValuesList])
		var insertionParams = insertionParamsByTaistiePartType[taistiePartType]

		taistiePartValuesList.forEach(function(taistiePartValue) {
			//некоторые части тейсти могут быть пустыми - пропустим их
			if (taistiePartValue.length > 0) {
				var details = {}
				details[insertionParams.source] = taistiePartValue
				chrome.tabs[insertionParams.method](taistedTabId, details)
			}
		})
	}
}

CentralPageTaistier.prototype.getTaistiesForUrl = function(url) {

	var allTaisties = this._taistiesStorage.getAllTaisties()
	var taistiesForUrl = []

	allTaisties.forEach(function(checkedTaistie) {
		if (checkedTaistie.fitsUrl(url)) {
			taistiesForUrl.push(checkedTaistie)
		}
	})

	return taistiesForUrl
}
