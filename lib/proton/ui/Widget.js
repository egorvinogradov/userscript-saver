Widget = function(){}

Widget.prototype.refresh = function(){
	if(!this._hasBeenPrerendered) {
		this._prerender()
		this._hasBeenPrerendered = true
	}
	this.fill()
}

Widget.prototype._prerender = function() {
	this.createUi()

	var childWidgets = this.getChildWidgets()
	console.log(childWidgets)
	childWidgets.forEach(function(childWidget) {
		childWidget.widget.init(childWidget.uiElement)
	})
}