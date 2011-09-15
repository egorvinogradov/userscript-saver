TabListener = function() {
}

TabListener.prototype.setTabTaister = function (tabTaister) {
	this._tabTaister = tabTaister
}

TabListener.prototype.setTaistieCombiner = function(taistieCombiner) {
	this._taistieCombiner = taistieCombiner
}

TabListener.prototype.startListeningToTabChange = function() {
	var self = this

	this._subscribeToTabChange(function(tabUrl, tabDescriptor) {
		self._taistTab(tabUrl, tabDescriptor)
	})
}

TabListener.prototype._taistTab = function(tabUrl, tabDescriptor) {
	var allTaistiesCssAndJs = this._taistieCombiner.getAllCssAndJsForUrl(tabUrl)
	var insertedJs = this._tabTaister.wrapTaistiesCodeToJs(allTaistiesCssAndJs)
	if(insertedJs !== null) {
		this._insertJsToTab(insertedJs, tabDescriptor)
	}
}

