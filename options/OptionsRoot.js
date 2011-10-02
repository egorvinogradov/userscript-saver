OptionsRoot = function() {}

OptionsRoot.prototype.prerender = function() {
	this._newTaistieWidget._element = $('<' + this._newTaistieWidget._tagName + '/>')
	this._element.append(this._newTaistieWidget._element)
}