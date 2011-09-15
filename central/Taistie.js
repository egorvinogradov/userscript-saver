Taistie = function(taistieData) {
	this._siteRegExp = taistieData.siteRegexp

	this._js = taistieData.js === undefined ? '' : taistieData.js
	this._css = taistieData.css === undefined ? '' : taistieData.css
}

Taistie.prototype.fitsUrl = function(url) {
	var urlRegexp = new RegExp(this._siteRegExp, 'g')
	return urlRegexp.test(url)
}

Taistie.prototype.getCss = function() {
	return this._css
}

Taistie.prototype.getJs = function() {
	return this._js
}
