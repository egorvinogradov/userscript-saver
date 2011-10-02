PopupOpenOptionsWidget = function() {}

PopupOpenOptionsWidget.prototype._tagName = 'button'

PopupOpenOptionsWidget.prototype.prerender = function() {
	var self = this

	this._element.text('New Taistie')
	this._element.click(function() {
			self._tabApi.openTab('options/options.html')
		}
	)
}