WidgetController = function() {
	this._widget = null
}

WidgetController.prototype.refresh = function() {
	if (!this._hasBeenPrerendered) {
		if (this._widget.prerender !== undefined) { this._widget.prerender()}
		this._hasBeenPrerendered = true
	}
	this._widget.fill()
}

WidgetController.prototype.init = function() {
	var self = this
	this._widget.getModelDepedencies().forEach(function(modelDependency) {
		modelDependency.listen(self)
	})
}