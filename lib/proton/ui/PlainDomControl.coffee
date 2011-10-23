class PlainDomControl
	#TODO: убрать if'ы на типы элементов и т.п. - через полиморфизм
	setDomAccessor: (jqueryElement) ->
		@_jqueryElement = jqueryElement

	getValue: ->
		if @_jqueryElement.attr('type') is 'checkbox'
			@_jqueryElement.is(':checked')
		else
			@_jqueryElement.val()

	setValueChangeListener: (listener) ->
		#TODO: check that element can have value
		@_jqueryElement.change =>
			listener @getValue(), @

	subscribeToEvent: (eventName, handler) ->
		@_jqueryElement.bind eventName, handler
