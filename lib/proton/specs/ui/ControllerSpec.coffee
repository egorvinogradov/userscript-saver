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

	it 'when rendering, inits DOM contents and children elements', ->
		expectedCalledMethods = [
			'_initDOM',
			'_initChildElements'
		]
		calledMethods = []
		for expected in expectedCalledMethods
			do (expected) ->
				controller[expected] = -> calledMethods.push expected

		controller.render()
		expect(calledMethods).toEqual expectedCalledMethods

	it 'inits DOM contents from template by @_domClass and creates @_localDomAccessor limited by contents root', ->
		controller._domClass = 'controllerClass'
		expectedDomElement = null
		controller._templateAccessor =
			getTemplateByClass: (templateClassValue) ->
				return expectedDomElement = templateClass: templateClassValue
		controller._newLocalDomAccessor = (domElement) -> localRoot: domElement

		controller._initDOM()
		expect(expectedDomElement.templateClass).toEqual 'controllerClass'
		expect(controller._localDomAccessor).toEqual localRoot: expectedDomElement

	it 'creates child elements from @_childElements, points them to their DOM elements and subscribes them to model events', ->
		childControls = []
		controller._newJqueryControl = ->
			newControl =
				contents: {}
				setDomAccessor: (domAccessorValue) -> @contents.domAccessor = domAccessorValue
				setValueChangeListener: (listener) -> @listener = listener
			childControls.push newControl
			return newControl

		controller._localDomAccessor =
			find: (selectorValue) -> return selector: selectorValue

		updatedAttributes = []
		controller.item =
			updateAttribute: (attributeName, value) ->
				updatedAttribute = {}
				updatedAttribute[attributeName] = value
				updatedAttributes.push updatedAttribute

		controller._childELementDescriptions =
			".childClassFoo": "modelPropertyFoo",
			".childClassBar": "modelPropertyBar"

		controller._initChildElements()
		expect((child.contents for child in childControls)).toEqual [domAccessor: selector: '.childClassFoo',
			domAccessor: selector: '.childClassBar']

		childControls[0].listener 'newFoo'
		childControls[1].listener 'newBar'
		expect(updatedAttributes).toEqual [{'modelPropertyFoo': 'newFoo'}, {'modelPropertyBar': 'newBar'}]

#	it '@render calls @refreshRender every time', ->
#		refreshRenderCalls = 0
#
#		controller.refreshRender = -> refreshRenderCalls++
#
#		controller.render()
#		expect(refreshRenderCalls).toEqual 1
#
#		controller.render()
#		expect(refreshRenderCalls).toEqual 2
