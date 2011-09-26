View = function(){}

View.prototype.render = function(tagName){
	this._parentView.createChildTag(tagName)
}