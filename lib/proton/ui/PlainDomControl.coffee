class PlainDomControl
	setDomAccessor: (domAccessor) ->
		assert domAccessor?.attr?, 'domAccessor should be valid jquery-like object'
		@_domAccessor = domAccessor

		innerControlConstructor = null
		if @_domAccessor.is 'input'
			isCheckBox = @_domAccessor.attr('type') is 'checkbox'
			innerControlConstructor = if isCheckBox then Checkbox else DefaultInput
		else
			innerControlConstructor = NonInput
		@_innerControl = new innerControlConstructor
		@_innerControl._domAccessor = @_domAccessor
	getDomAccessor: -> @_domAccessor

	getValue: -> @_innerControl.getValue()
	setValue: (newValue) -> @_innerControl.setValue newValue

	setValueChangeListener: (listener) ->
		#TODO: check that element can have value
		@_domAccessor.change =>
			listener @getValue(), @

	#TODO: rename properly
	subscribeToEvent: (eventName, handler) ->
		@_domAccessor.bind eventName, handler

	class Checkbox
		getValue: -> @_domAccessor.is ':checked'
		setValue: (newValue) ->
			assert(newValue == true || newValue == false, 'checkbox accepts only true/false')
			@_domAccessor.attr('checked', newValue)

	class DefaultInput
		getValue: -> @_domAccessor.val()
		setValue: (newValue) -> @_domAccessor.val newValue

	class NonInput
		getValue: -> @_domAccessor.html()
		setValue: (newValue) -> @_domAccessor.html newValue
