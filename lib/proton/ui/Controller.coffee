class Controller extends Spine.Controller
	setModel: (model) ->
		assert model?.bind?, 'model should exist and have method \'bind\''
		@model = model
		@model.bind "update",  @redraw
		@model.bind "destroy", @destroy

	render: ->
		@_initDOM()
		@_initChildElements()
	
	_initDOM: ->
		@_localDomAccessor = @_templateAccessor.getDomFromTemplateByClass @_domClass

	_initChildElements: ->
		for selector, elementDescription of @_childELementDescriptions
			do (selector, elementDescription) =>
				elementDescription ?= {}
				#TODO: переименовать - убрать 'jquery'
				jqueryControl = @_newJqueryControl()
				jqueryControl.setDomAccessor @_localDomAccessor.findChild selector

				if elementDescription.modelAttribute?
					jqueryControl.setValueChangeListener (newValue) =>
						@model.updateAttribute elementDescription.modelAttribute, newValue

				if elementDescription.events?
					for eventName, eventHandler of elementDescription.events
						do(eventName, eventHandler) =>
							jqueryControl.subscribeToEvent eventName, => eventHandler.apply @

	redraw: =>
		if not @_prerendered
			@_initialRender()
			@_prerendered = true

		if @refreshRender?
			@refreshRender()

	_initialRender: ->
		@delegateEvents()
		@refreshElements()
