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
			trigger: (eventName) ->
				this['event_' + eventName]()
			event_update: -> @updated = true
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
			mockModel.trigger 'destroy'

			domElementRemoved = false
			controller._templateAccessor =
				getDomFromTemplateByClass: ->
					remove: -> domElementRemoved = true

			controller.render()
			mockModel.trigger 'destroy'
			expect(domElementRemoved).toBeTruthy()

	it 'gives model by getModel()', ->
		controller.setModel mockModel
		expect(controller.getModel()).toBe mockModel
