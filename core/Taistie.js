Taistie = function() {}

Taistie.prototype.setTaistieData = function(taistieData) {
	assert(!!taistieData.urlRegexp, 'url regexp shoul be given')
	this._urlRegexp = taistieData.urlRegexp

	this._js = !taistieData.js ? '' : taistieData.js
	this._css = !taistieData.css ? '' : taistieData.css
}

Taistie.prototype.fitsUrl = function(url) {
	var urlRegexp = new RegExp(this._urlRegexp, 'g')
	return urlRegexp.test(url)
}

Taistie.prototype.getCss = function() {
	return this._css
}

Taistie.prototype.getJs = function() {
	return this._js === '' ? '' : '(function(){' + this._js + '})();'
}
