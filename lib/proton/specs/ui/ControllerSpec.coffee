describe 'Controller', ->
	controller = null
	childControls = null
	class mockChildControl
		constructor: ->
		setDomAccessor: (domAccessorValue) -> @domAccessor = domAccessorValue
		getDomAccessor: -> @domAccessor
		subscribeToEvent: (eventName, listener) ->
			@['fire_' + eventName] = listener

	beforeEach ->
		controller = new Controller
		controller._newPlainDomControl = ->
			newChildControl = new mockChildControl
			childControls.push newChildControl
			return newChildControl
		childControls = []

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

			it 'points them to their DOM elements and stores them in @childElementsBySelectors', ->
				controller.render()
				expect(child.domAccessor for child in childControls).toEqual [
					'foundChild: .childClassFoo',
					'foundChild: .childClassBar']
				expect(childElement for selector, childElement of controller._childElementsBySelectors).toEqual childControls

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

