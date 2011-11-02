describe 'SingleItemController', ->
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
		controller = new SingleItemController
		controller.getChildELementDescriptions = ->

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

				controller.getChildELementDescriptions = ->
					".childClassFoo":
						modelAttribute: 'foo'
					".childClassBar":
						modelAttribute: 'bar'

				controller._templateAccessor =
					getDomFromTemplateByClass: ->
						find: (selectorValue) -> selectorValue

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
