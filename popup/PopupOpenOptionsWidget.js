PopupOpenOptionsWidget = function(){}

PopupOpenOptionsWidget.prototype.render = function(parentElement){

	var self = this
	this._element = this._jqueryFunction('<button/>', {
		text: 'New taistie',
		click: function(){
			//TODO: API вынести в отдельную зависимость
			chrome.tabs.create({url: 'options.html'})
		}
	})
	parentElement.append(this._element)
}