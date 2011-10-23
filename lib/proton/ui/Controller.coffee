class Controller extends Spine.Controller
	constructor: ->
		@_rendered = false

	setModel: (model) ->
		assert model?.bind?, 'model should exist and have method \'bind\''
		@_model = model
		@_model.bind "update",  @redraw
		@_model.bind "destroy", @destroy

	render: ->
		@_initDOM()
		@_initChildElements()
		@_rendered = true

	_initDOM: ->
		@_localDomAccessor = @_templateAccessor.getDomFromTemplateByClass @_domClass

	_initChildElements: ->
		@_childElements = {}
		for selector, elementDescription of @_childELementDescriptions
			do (selector, elementDescription) =>
				elementDescription ?= {}

				childControl = @_createChildControl selector, elementDescription
				@_bindControlToModelAtribute childControl, elementDescription.modelAttribute
				@_listenToControlEvents childControl, elementDescription.events

	_createChildControl: (selector, elementDescription) ->
		plainDomControl = @_newPlainDomControl()
		plainDomControl.setDomAccessor @_localDomAccessor.findChild selector
		return plainDomControl

	_bindControlToModelAtribute: (control, modelAttribute) ->
		if modelAttribute?
			control.setValueChangeListener (newValue) =>
				@_model.updateAttribute modelAttribute, newValue

	_listenToControlEvents: (control, events) ->
		if events?
			for eventName, eventHandler of events
				do(eventName, eventHandler) =>
					control.subscribeToEvent eventName, => eventHandler.apply @

	redraw: =>
		if @refreshRender?
			@refreshRender()

	destroy: =>
		if @_rendered
			@_localDomAccessor.remove()
