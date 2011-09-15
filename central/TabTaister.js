TabTaister = function(){
}

TabTaister.prototype.setTaistieCombiner = function(taistieCombiner) {
	this._taistieCombiner = taistieCombiner
}

TabTaister.prototype.setTabApi = function(tabApi) {
	this._tabApi = tabApi
}

TabTaister.prototype.startListeningToTabChange = function() {
	var self = this

	this._tabApi.subscribeToTabChange(function(tabUrl, tabDescriptor){
		self._taistTab(tabUrl, tabDescriptor)
	})
}

TabTaister.prototype._taistTab = function(tabUrl, tabDescriptor) {
	var allTaistiesCssAndJs = self._taistieCombiner.getAllCssAndJsForUrl(tabUrl)
	var finalCodeToInsert = this._getCodeToInsert(allTaistiesCssAndJs)

	self._tabApi.insertJsToTab(finalCodeToInsert, tabDescriptor)
}

TabTaister.prototype._getCodeToInsert = function(cssAndJsCode) {
	return '(' + this._insertFunctionCode + ')(' + cssAndJsCode.toString() + ')'
}

TabTaister.prototype._insertFunctionCode = function(cssAndJsCode){
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

	['css', 'js'].forEach(function(codeType){
		insertCode(insertedElementDescriptors[codeType], cssAndJsCode[codeType])
	})

	function insertCode(elementDescriptor, code) {
		var insertedElement = document.createElement(elementDescriptor.tagName)
		insertedElement.setAttribute('type', elementDescriptor.type)
		insertedElement.textContent = code
		document.querySelector('body').appendChild(insertedElement)
	}
}.toString()