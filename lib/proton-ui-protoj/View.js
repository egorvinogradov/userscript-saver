View = function(){}

View.prototype.render = function(parentView){
	parentView.createChildElement(this._tagName)
}

View.prototype.createChildElement = function(tagName) {
	var childElement = this._jqueryFunction('<' + tagName + '/>')
	this._element.append(childElement)
	return childElement
}