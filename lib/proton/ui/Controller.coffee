class Controller
	constructor: ->
		@_rendered = false

	setModel: (model) ->
		assert model?.bind?, 'model should exist and have method \'bind\''
		@_model = model
		@_model.bind "update",  @_redraw
		@_model.bind "destroy", @_destroy

	getModel: -> @_model

	render: ->
		if not @_rendered
			@_initDOM()
			@_initChildElements()
			@_rendered = true
		@_redraw()

	_initDOM: ->
		@_localDomAccessor = @_templateAccessor.getDomFromTemplateByClass @_domClass

	getDomAccessor: ->
		assert @_rendered, 'should be rendered before using @getDomAccessor'
		return @_localDomAccessor

	_initChildElements: ->
		@childElementsBySelectors = {}
		for selector, elementDescription of @_childELementDescriptions
			do (selector, elementDescription) =>
				elementDescription ?= {}

				childControl = @_createChildControl selector
				@childElementsBySelectors[selector] = childControl
				@_bindControlToModelAtribute childControl, elementDescription.modelAttribute
				@_listenToControlEvents childControl, elementDescription.events

	_createChildControl: (selector) ->
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

	_redraw: =>
		if @_model?
			for selector, elementDescription of @_childELementDescriptions
				do (selector, elementDescription) =>
					if elementDescription?.modelAttribute?
						control = @childElementsBySelectors[selector]
						newValue = @_model[elementDescription.modelAttribute]
						control.setValue newValue

		@customRedraw?()

	_destroy: =>
		if @_rendered
			@_localDomAccessor.remove()
