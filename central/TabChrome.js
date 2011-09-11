TabChrome = function(tabId, tabUrl) {
	this._id = tabId
	this._url = tabUrl
}

TabChrome.prototype.getUrl = function() {
	return this._url
}

TabChrome.prototype._api = chrome.tabs

TabChrome.prototype.insertJsFile = function(jsFileName) {
	this._api.executeScript(this._id, {file: jsFileName})
}

TabChrome.prototype.insertCss = function(cssCode) {
	this._api.insertCss(this._id, {code: cssCode})
}

TabChrome.prototype.insertJs = function(jsCode) {
	this._api.executeScript(this._id, {code: jsCode})
}