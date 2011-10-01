Widget = function(){}

Widget.prototype.init = function(uiElement){
	this._uiElement = uiElement
	this._uiApi.subscribeOnShow(this._uiElement, this)
}

Widget.prototype.render = function(){
	if(!this._hasBeenPrerendered) {
		this.prerender()
		this._hasBeenPrerendered = true
	}
	this.fill()
}