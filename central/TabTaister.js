TabTaister = function() {
}

TabTaister.prototype.setTaistieCombiner = function(taistieCombiner) {
	this._taistieCombiner = taistieCombiner
}

TabTaister.prototype.setTabApi = function(tabApi) {
	this._tabApi = tabApi
}

TabTaister.prototype.startListeningToTabChange = function() {
	var self = this

	this._tabApi.subscribeToTabChange(function(tabUrl, tabDescriptor) {
		self._taistTab(tabUrl, tabDescriptor)
	})
}

TabTaister.prototype._taistTab = function(tabUrl, tabDescriptor) {
	var allTaistiesCssAndJs = this._taistieCombiner.getAllCssAndJsForUrl(tabUrl)

	if (allTaistiesCssAndJs.js.length > 0 || allTaistiesCssAndJs.css.length > 0) {
		var finalCodeToInsert = this._getCodeToInsert(allTaistiesCssAndJs)
		this._tabApi.insertJsToTab(finalCodeToInsert, tabDescriptor)
	}
}

TabTaister.prototype._getCodeToInsert = function(cssAndJsCode) {
	return '(' + this._insertFunction.toString() + ')(' + JSON.stringify(cssAndJsCode) + ')'
}

TabTaister.prototype._insertFunction = function(cssAndJsCode) {
	var insertedElementDescriptors = {
		css: {
			tagName: 'style',
			type: 'text/css'
		},
		js: {
			tagName: 'script',
			type: 'text/javascript'
		}
	}

			['css','js'].forEach(function(codeType) {
		if (cssAndJsCode[codeType].length
				> 0) { insertCode(insertedElementDescriptors[codeType], cssAndJsCode[codeType])}
	})

	function insertCode(elementDescriptor, code) {
		var insertedElement = document.createElement(elementDescriptor.tagName)
		insertedElement.setAttribute('type', elementDescriptor.type)
		insertedElement.textContent = code
		document.querySelector('body').appendChild(insertedElement)
	}
}