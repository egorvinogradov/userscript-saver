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
		@_localDomAccessor = @_templateAccessor.getDomFromTemplateByClass @domClass

	getDomAccessor: ->
		assert @_rendered, 'should be rendered before using @getDomAccessor'
		return @_localDomAccessor

	getChildDomAccessorByAlias: (alias) ->
		childElement = null
		assert alias, 'alias should be valid'

		for selector, description of @childELementDescriptions
			if description?.alias == alias
				childElement = @_childElementsBySelectors[selector]

		#TODO: проверять: алиас должен быть уникальным
		assert childElement?, 'alias should exist'
		return childElement.getDomAccessor()

	_initChildElements: ->
		@_childElementsBySelectors = {}
		for selector, elementDescription of @childELementDescriptions
			do (selector, elementDescription) =>
				elementDescription ?= {}

				childControl = @_createChildControl selector
				@_childElementsBySelectors[selector] = childControl
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
				#TODO: контракт: eventHandler должен быть установлен и быть функцией
				do(eventName, eventHandler) =>
					control.subscribeToEvent eventName, => eventHandler.apply @

	_redraw: =>
		if @_model?
			for selector, elementDescription of @childELementDescriptions
				do (selector, elementDescription) =>
					if elementDescription?.modelAttribute?
						control = @_childElementsBySelectors[selector]
						newValue = @_model[elementDescription.modelAttribute]
						control.setValue newValue

		@customRedraw?()

	_destroy: =>
		if @_rendered
			@_localDomAccessor.remove()
