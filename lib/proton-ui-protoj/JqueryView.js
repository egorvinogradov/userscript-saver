JqueryView = function(){}

JqueryView.prototype.render = function(parentElement){
	//TODO: check tag correctness?
	this._element = this._jqueryFunction('<' + this._tagName + '/>')
	parentElement.append(this._element)
}