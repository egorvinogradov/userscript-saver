class PopupOpenOptionsWidget
	_tagName: 'button'

	prerender: ->

		#todo: taistieEnabled вынести в модель
		@storage = new LocalStorage()
		@taistieEnabled = @storage.get('taistieEnabled')
	
		@fill()
	
		@_element.change =>
				@taistieEnabled = !@taistieEnabled
				@storage.put 'taistieEnabled', @taistieEnabled
	
				chrome.tabs.getSelected null, (tab) ->
					chrome.tabs.update tab.id, {url: tab.url}, -> window.close()

	fill: ->
		@_element.attr 'checked', @taistieEnabled
