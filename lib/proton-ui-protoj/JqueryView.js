JqueryView = function(){}

JqueryView.prototype.render = function(parentView){
	this._element = parentView.createChildElement(this._tagName)
}

JqueryView.prototype.createChildElement = function(tagName) {
	var childElement = this._jqueryFunction('<' + tagName + '/>')
	this._element.append(childElement)
	return childElement
}