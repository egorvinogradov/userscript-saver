describe 'Controller', ->
	controller = null
	beforeEach ->
		controller = new Controller

	it 'accepts model through setModel and subscribes to its events', ->
		model =
			bind: (eventName, eventHandler) ->
				this[eventName] = eventHandler
			fire: (eventName) ->
				this[eventName]()

		controller.render = ->
			return 'rendered'
		controller.destroy = ->
			return 'destroyed'

		controller.setModel model

		expect(controller.item).toEqual model
		expect(model.fire 'update').toEqual controller.render()
		expect(model. fire 'destroy').toEqual controller.destroy()

	it 'requires to have handlers for model events and existing model', ->

		expect(-> controller.setModel null).toThrow new AssertException('model should exist')
		expect(-> controller.setModel {}).toThrow new AssertException('should have methods \'render\' and \'destroy\'')

		controller.render = ->
		controller.destroy = ->
		controller.setModel bind: ->
