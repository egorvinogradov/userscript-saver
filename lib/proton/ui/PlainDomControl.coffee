class PlainDomControl
	#TODO: убрать if'ы на типы элементов и т.п. - через полиморфизм
	setDomAccessor: (domAccessor) ->
		@_domAccessor = domAccessor
		isCheckBox = @_domAccessor.attr('type') is 'checkbox'
		@_innerControl = new (if isCheckBox then Checkbox else DefaultInput)
		@_innerControl._domAccessor = @_domAccessor

	getValue: -> @_innerControl.getValue()
	setValue: (newValue) -> @_innerControl.setValue newValue

	setValueChangeListener: (listener) ->
		#TODO: check that element can have value
		@_domAccessor.change =>
			listener @getValue(), @

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
