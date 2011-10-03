NewTaistieWidget = function() {}

NewTaistieWidget.prototype._tagName = 'div'
NewTaistieWidget.prototype.fill = function() {
	this._element.text(this._newTaistie._urlRegexp)
}

NewTaistieWidget.prototype.getModelDepedencies = function(){
	return [this._newTaistie]
}