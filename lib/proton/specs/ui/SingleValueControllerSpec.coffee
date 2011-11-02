describe 'SingleValueController', ->
	it 'adds external listeners to any its events', ->

		handledEvents = {}
		controller = new SingleValueController
			subscribeToEvent: (eventName, handler) -> handledEvents[eventName] = handler
		#events can be not given
		controller.init {}

		events =
			'foo': -> 'foo fired!'
			'bar': -> 'bar fired!'
		controller.init {events}
		expect(handledEvents).toEqual events

	it 'updates model when control value changes, and vise versa', ->
		changeListener = null
		mockDomElement =
			setValueChangeListener: (listener) ->
				changeListener = listener
			setValue: (newValue) -> @value = newValue
		mockModel =
			updateAttribute: (attributeName, value) -> @attrs[attributeName] = value
			bind: (eventName, handler) -> @eventHandlers[eventName] = handler
			attrs: {}
			attributes: -> @attrs
			eventHandlers: {}

		controller = new SingleValueController mockDomElement
		controller.init
			model: mockModel
			modelAttribute: 'foo'
		changeListener 'new from control'
		expect(mockModel.attrs).toEqual foo: 'new from control'

		mockModel.attrs.foo = 'new from model'
		mockModel.eventHandlers['update']()
		expect(mockDomElement.value).toEqual 'new from model'
