TabTaister = function() {
}

TabTaister.prototype.setTaistieWrapper = function (taistieWrapper) {
	this._taistieWrapper = taistieWrapper
}

TabTaister.prototype.setTaistieCombiner = function(taistieCombiner) {
	this._taistieCombiner = taistieCombiner
}

TabTaister.prototype.startListeningToTabChange = function() {
	var self = this

	this._subscribeToTabChange(function(tabUrl, tabDescriptor) {
		self._taistTab(tabUrl, tabDescriptor)
	})
}

TabTaister.prototype._taistTab = function(tabUrl, tabDescriptor) {
	var allTaistiesCssAndJs = this._taistieCombiner.getAllCssAndJsForUrl(tabUrl)
	var insertedJs = this._taistieWrapper.wrapTaistiesCodeToJs(allTaistiesCssAndJs)
	if(insertedJs !== null) {
		this._insertJsToTab(insertedJs, tabDescriptor)
	}
}

