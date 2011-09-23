PopupWidget = function() {
	this.child = new PopupOpenOptionsWidget()
}

PopupWidget.prototype.show = function() {
	$('body').append('<div>top popup widget</div>')
	this.child.show()
}
