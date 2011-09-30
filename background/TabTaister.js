TabTaister = function() {}

TabTaister.prototype.startListeningToTabChange = function() {
	var self = this

	this._tabApi.subscribeToTabChange(function(tabUrl, tabDescriptor) {
		self._taistTab(tabUrl, tabDescriptor)
	})
}

TabTaister.prototype._taistTab = function(tabUrl, tabDescriptor) {
	var allTaistiesCssAndJs = this._dTaistieCombiner.getAllCssAndJsForUrl(tabUrl)
	var insertedJs = this._dTaistieWrapper.wrapTaistiesCodeToJs(allTaistiesCssAndJs)
	if(insertedJs !== null) {
		this._tabApi.insertJsToTab(insertedJs, tabDescriptor)
	}
}

