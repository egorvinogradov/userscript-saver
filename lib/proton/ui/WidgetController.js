WidgetController = function() {}

WidgetController.prototype.refresh = function() {
	if (!this._hasBeenPrerendered) {
		this._widget.prerender()
		this._hasBeenPrerendered = true
	}
	this._widget.fill()
}

WidgetController.prototype.setWidget = function(widget) {
	this._widget = widget
	if (this._widget.getModelDepedencies !== undefined) {
		var self = this
		this._widget.getModelDepedencies().forEach(function(modelDependency) {
			self._dependencyDispatcher.listen(modelDependency, self)
		})
	}
}