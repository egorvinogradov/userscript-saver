describe 'Controller', ->
	controller = null
	beforeEach ->
		controller = new Controller

	it 'accepts model through @setModel and subscribes to its events "redraw" and "destroy"', ->
		calledHandlers = []
		controller.redraw = -> calledHandlers.push 'redraw'
		controller.destroy = -> calledHandlers.push 'destroyed'

		model =
			bind: (eventName, eventHandler) ->
				this['fire_' + eventName] = eventHandler

		controller.setModel model
		expect(controller.item).toEqual model

		model['fire_destroy']()
		model['fire_update']()
		expect(calledHandlers).toEqual ['destroyed', 'redraw']


	it 'checks for existing model', ->
		exceptionMsg = 'model should exist and have method \'bind\''
		expect(setter).toThrow new AssertException(exceptionMsg) for setter in [
			-> controller.setModel null,
			-> controller.setModel {}
		]

		#check that correct model deosn't cause an exception
		controller.setModel	bind: ->

	describe 'render: creates DOM contents and children elements', ->

		it 'gets DOM contents from template by @_domClass', ->
			expectedSelector = null
			controller._domClass = 'controllerClass'
			controller._templateAccessor =
				getDomFromTemplateByClass: (templateClassValue) ->
					expectedSelector = templateClassValue
			controller.render()
			expect(expectedSelector).toEqual 'controllerClass'

		it 'creates child elements from @_childElements, points them to their DOM elements and subscribes them to model events', ->
			controller._templateAccessor =
				getDomFromTemplateByClass: ->
					find: (selectorValue) -> return selector: selectorValue

			childControls = []
			controller._newJqueryControl = ->
				newControl =
					contents: {}
					setDomAccessor: (domAccessorValue) -> @contents.domAccessor = domAccessorValue
					setValueChangeListener: (listener) -> @listener = listener
				childControls.push newControl
				return newControl

			updatedAttributes = []
			controller.item =
				updateAttribute: (attributeName, value) ->
					updatedAttribute = {}
					updatedAttribute[attributeName] = value
					updatedAttributes.push updatedAttribute

			controller._childELementDescriptions =
				".childClassFoo": "modelPropertyFoo",
				".childClassBar": "modelPropertyBar"

			controller.render()
			expect((child.contents for child in childControls)).toEqual [domAccessor: selector: '.childClassFoo',
				domAccessor: selector: '.childClassBar']

			childControls[0].listener 'newFoo'
			childControls[1].listener 'newBar'
			expect(updatedAttributes).toEqual [{'modelPropertyFoo': 'newFoo'}, {'modelPropertyBar': 'newBar'}]
