PopupOpenOptionsWidget = function() {}

PopupOpenOptionsWidget.prototype._tagName = 'button'

PopupOpenOptionsWidget.prototype.prerender = function() {
	var self = this

	//todo: taistieEnabled вынести в модель
	this.storage = new LocalStorage()
	this.taistieEnabled = this.storage.get('taistieEnabled')

	this.fill()

	this._element.change(function() {
			self.taistieEnabled = !self.taistieEnabled
			self.storage.put('taistieEnabled', self.taistieEnabled)

			chrome.tabs.getSelected(null, function(tab) {
				chrome.tabs.update(tab.id, {url: tab.url}, function(){window.close()})
			})
		}
	)
}

PopupOpenOptionsWidget.prototype.fill = function() {
	this._element.attr('checked', this.taistieEnabled)
}
