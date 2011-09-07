Taistie = function(taistieData) {
	this._siteRegExp = taistieData.siteRegexp;
	this._contents = taistieData.contents;
}

Taistie.prototype.fitsUrl = function(url) {
	var urlRegexp = new RegExp(this._siteRegExp, 'g');
	return urlRegexp.test(url)
}