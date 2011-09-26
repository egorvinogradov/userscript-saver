Widget = function(){}

Widget.prototype.render = function(){
	this._view.render(this._tagName, this._additionalOptions)
}