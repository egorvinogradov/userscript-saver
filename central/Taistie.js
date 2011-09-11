Taistie = function(taistieData) {
	this._siteRegExp = taistieData.siteRegexp

	this._extractTaistieContents(taistieData.contents)
}

Taistie.prototype._extractTaistieContents = function(rawContents) {

	assert(rawContents !== undefined && rawContents !== null, "taistieData should contain 'contents'")
	this._jslibs = getContentOrDefault('jslibs', [])
	this._js = getContentOrDefault('js', '')
	this._css = getContentOrDefault('css', '')

	function getContentOrDefault(contentType, defaultValue) {
		var content = rawContents[contentType]
		return (content === undefined || content === null) ? defaultValue : content
	}
}

Taistie.prototype.fitsUrl = function(url) {
	var urlRegexp = new RegExp(this._siteRegExp, 'g')
	return urlRegexp.test(url)
}

Taistie.prototype.getJsLibs = function() {
	return this._jslibs
}

Taistie.prototype.getCss = function() {
	return this._css
}

Taistie.prototype.getJs = function() {
	return this._js
}
