describe 'Controller', ->
	controller = null
	mockModel = null
	childControls = null
	class mockChildControl
		constructor: ->
			@contents = {}
		setDomAccessor: (domAccessorValue) -> @contents.domAccessor = domAccessorValue
		getDomAccessor: -> @contents.domAccessor
		setValue: (value) -> @value = value
		getValue: -> @value
		subscribeToEvent: (eventName, listener) ->
			@['fire_' + eventName] = listener
		setValueChangeListener: (listener) -> @listener = listener
	
	beforeEach ->
		controller = new Controller
		controller._newPlainDomControl = ->
			newChildControl = new mockChildControl
			childControls.push newChildControl
			return newChildControl
		mockModel =
			bind: (eventName, eventHandler) ->
				this['event_' + eventName] = eventHandler
			fire: (eventName) ->
				this['event_' + eventName]()
		childControls = []

	describe 'accepts model through @setModel', ->
		it 'checks for existing model', ->
			ex = new AssertException 'model should exist and have method \'bind\''
			expect(-> controller.setModel invalidModel).toThrow ex for invalidModel in [null, {}]

			#check that correct model doesn't cause an exception
			controller.setModel	mockModel

		it 'removes its DOM element from DOM when model is destroyed', ->
			controller.setModel mockModel

			#if not rendered yet, does nothing
			mockModel.fire 'destroy'

			domElementRemoved = false
			controller._templateAccessor =
				getDomFromTemplateByClass: ->
					remove: -> domElementRemoved = true

			controller.render()
			mockModel.fire 'destroy'
			expect(domElementRemoved).toBeTruthy()

		describe 'when model changes', ->
			it 'renews its child element values', ->
				controller.setModel mockModel

				controller.childELementDescriptions =
					".childClassFoo":
						modelAttribute: 'foo'
					".childClassBar":
						modelAttribute: 'bar'

				controller._templateAccessor =
					getDomFromTemplateByClass: ->
						findChild: (selectorValue) -> selectorValue

				mockModel.foo = 'initialFoo'

				controller.render()
				fooControl = childControls[0]
				barControl = childControls[1]
				expect(fooControl.value).toEqual 'initialFoo'
				expect(barControl.value).toEqual null

				mockModel.foo = 'newFoo1'
				mockModel.bar = 'newBar1'
				mockModel.fire 'update'
				expect(fooControl.value).toEqual 'newFoo1'
				expect(barControl.value).toEqual 'newBar1'

				mockModel.foo = 'newFoo2'
				mockModel.fire 'update'
				expect(fooControl.value).toEqual 'newFoo2'
				expect(barControl.value).toEqual 'newBar1'

			it 'if has @_customRedraw, calls it', ->
				controller.setModel mockModel

				#if there is no customRedraw, does nothing
				mockModel.fire 'update'

				customRedrawCalled = false
				controller.customRedraw = -> customRedrawCalled = true
				mockModel.fire 'update'
				expect(customRedrawCalled).toBeTruthy()

	it 'gives model by getModel()', ->
		controller.setModel mockModel
		expect(controller.getModel()).toBe mockModel

	describe 'render: creates DOM contents and children elements', ->
		it 'gets DOM contents from template by @domClass', ->
			expectedSelector = null
			controller.domClass = 'controllerClass'
			controller._templateAccessor =
				getDomFromTemplateByClass: (templateClassValue) ->
					expectedSelector = templateClassValue
			controller.render()
			expect(expectedSelector).toEqual 'controllerClass'

		describe 'creates child elements from @_childElementDescriptions', ->
			beforeEach ->
				controller._templateAccessor =
					getDomFromTemplateByClass: ->
						find: (selectorValue) -> 'foundChild: ' + selectorValue

				controller.childELementDescriptions =
					".childClassFoo": null,
					".childClassBar": null

				controller.setModel mockModel

			it 'points them to their DOM elements and stores them in @childElementsBySelectors', ->
				controller.render()
				expect(child.contents for child in childControls).toEqual [
					{domAccessor: 'foundChild: .childClassFoo'},
					{domAccessor: 'foundChild: .childClassBar'}]
				expect(childElement for selector, childElement of controller._childElementsBySelectors).toEqual childControls

			it 'changes model when their values change', ->
				updatedAttributes = []
				mockModel.updateAttribute = (attributeName, value) ->
						updatedAttribute = {}
						updatedAttribute[attributeName] = value
						updatedAttributes.push updatedAttribute

				controller.childELementDescriptions =
					".childClassFoo":
						modelAttribute: "modelPropertyFoo",
					".childClassBar": {}
				controller.render()

				#if no model property is given, value changes are ignored
				expect(childControls[1].listener).not.toBeDefined()

				childControls[0].listener 'newFoo'
				expect(updatedAttributes).toEqual [{'modelPropertyFoo': 'newFoo'}]

			it 'subscribes to their different events with its methods', ->

				#use controller attribute to check handler context binding to controller
				controller.onBar = -> @barFired = true
				controller.childELementDescriptions =
					".childClassFoo":
						events:
							"eventBar": controller.onBar

				controller.render()
				childControls[0]['fire_eventBar']()
				expect(controller.barFired).toBeTruthy()

	it 'getDomAccessor() returns domAccessor after rendering', ->
		mockDomAccessor = {}
		controller._templateAccessor =
			getDomFromTemplateByClass: (templateClass) -> mockDomAccessor

		expectedException = new AssertException 'should be rendered before using @getDomAccessor'
		expect(-> controller.getDomAccessor()).toThrow expectedException

		controller.render()
		expect(controller.getDomAccessor()).toBe mockDomAccessor

	it 'getChildDomAccessorByAlias: gets child dom accessor by its alias', ->
		childDomAccessor = {}
		controller._templateAccessor =
			getDomFromTemplateByClass: ->
				find: (selectorValue) -> childDomAccessor
		controller.childELementDescriptions =
			".childClass":
				alias: "someChild"

		controller.render()
		expect(controller.getChildDomAccessorByAlias 'someChild').toBe childDomAccessor
		expect(-> controller.getChildDomAccessorByAlias null).toThrow new AssertException 'alias should be valid'
		expect(-> controller.getChildDomAccessorByAlias 'noChild').toThrow new AssertException 'alias should exist'

