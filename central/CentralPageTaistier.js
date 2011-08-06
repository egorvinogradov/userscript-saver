CentralPageTaister = function() {};

CentralPageTaister.prototype.TaistTabUp = function(taisties, taistedTabId) {
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
	};

	var insertTaistiePart = function(taistedTabId, taistiePartType, uncheckedTaistiePartValuesList) {
		//только библиотеки (jslib) содержат список значений, css и js - единичные значения
		var taistiePartValuesList = (taistiePartType == 'jslib' ? uncheckedTaistiePartValuesList : [
			uncheckedTaistiePartValuesList]);
		var insertionParams = insertionParamsByTaistiePartType[taistiePartType];

		taistiePartValuesList.forEach(function(taistiePartValue) {
			var details = {};
			details[insertionParams.source] = taistiePartValue;
			chrome.tabs[insertionParams.method](taistedTabId, details)
		});
	}

	taisties.forEach(function(currentTaistie) {
		var orderedTaistiePartTypes = ['jslib', 'css', 'js'];
		orderedTaistiePartTypes.forEach(function(taistiePartType) {
			if (taistiePartType in currentTaistie) {
				insertTaistiePart(taistedTabId, taistiePartType, currentTaistie[taistiePartType])
			}
		})
	})
};
