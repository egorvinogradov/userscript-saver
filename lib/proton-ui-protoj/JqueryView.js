JqueryView = function(){}

JqueryView.prototype.render = function(parentElement){
	this._element = this._jqueryFunction('<' + this._tagName + '/>')
	parentElement.append(this._element)
}