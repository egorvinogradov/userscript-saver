class PlainDomControl
	#TODO: убрать if'ы на типы элементов и т.п. - через полиморфизм
	setDomAccessor: (domAccessor) ->
		@_domAccessor = domAccessor

	getValue: ->
		if @_domAccessor.attr('type') is 'checkbox'
			@_domAccessor.is(':checked')
		else
			@_domAccessor.val()

	setValueChangeListener: (listener) ->
		#TODO: check that element can have value
		@_domAccessor.change =>
			listener @getValue(), @

	subscribeToEvent: (eventName, handler) ->
		@_domAccessor.bind eventName, handler
