PopupOpenOptionsWidget = function(){}

PopupOpenOptionsWidget.prototype.render = function(parentElement){
	this._element = this._jqueryFunction('<button/>', {
		text: 'New taistie',
		click: function(){
			this._tabApi.openTab('options/options.html')
		}
	})
	parentElement.append(this._element)
}