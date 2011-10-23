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
		expect(controller.model).toBe model

		model['fire_destroy']()
		model['fire_update']()
		expect(calledHandlers).toEqual ['destroyed', 'redraw']


	it 'checks for existing model', ->
		exceptionMsg = 'model should exist and have method \'bind\''
		expect(setter).toThrow new AssertException(exceptionMsg) for setter in [
			-> controller.setModel null,
			-> controller.setModel {}
		]

		#check that correct model doesn't cause an exception
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

		describe 'creates child elements from @_childElementDescriptions', ->
			childControls = null
			class mockChildControl
				constructor: ->
					@contents = {}
				setDomAccessor: (domAccessorValue) -> @contents.domAccessor = domAccessorValue

			beforeEach ->
				controller._templateAccessor =
					getDomFromTemplateByClass: ->
						findChild: (selectorValue) -> 'foundChild: ' + selectorValue
				childControls = []
				controller._newPlainDomControl = ->
					newChildControl = new mockChildControl
					childControls.push newChildControl
					return newChildControl

				controller._childELementDescriptions =
					".childClassFoo": null,
					".childClassBar": null

			it 'points them to their DOM elements', ->
				controller.render()
				expect((child.contents for child in childControls)).toEqual [
					{domAccessor: 'foundChild: .childClassFoo'},
					{domAccessor: 'foundChild: .childClassBar'}]

			it 'changes model when their values change', ->
				mockChildControl::setValueChangeListener = (listener) -> @listener = listener
				updatedAttributes = []
				controller.model =
					updateAttribute: (attributeName, value) ->
						updatedAttribute = {}
						updatedAttribute[attributeName] = value
						updatedAttributes.push updatedAttribute

				controller._childELementDescriptions =
					".childClassFoo":
						modelAttribute: "modelPropertyFoo",
					".childClassBar": {}
				controller.render()

				#if no model property is given, value changes are ignored
				expect(childControls[1].listener).not.toBeDefined()

				childControls[0].listener 'newFoo'
				expect(updatedAttributes).toEqual [{'modelPropertyFoo': 'newFoo'}]

			it 'subscribes to their different events byt its methods', ->
				mockChildControl::subscribeToEvent = (eventName, listener) ->
									@['fire_' + eventName] = listener

				#use controller attribute to check handler context binding to controller
				controller.onBar = -> @barFired = true
				controller._childELementDescriptions =
					".childClassFoo":
						events:
							"eventBar": controller.onBar

				controller.render()
				childControls[0]['fire_eventBar']()
				expect(controller.barFired).toBeTruthy()



