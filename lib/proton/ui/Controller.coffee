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
		for selector, attributeName of @_childELementDescriptions
			do (selector, attributeName) =>
				jqueryControl = @_newJqueryControl()
				jqueryControl.setDomAccessor @_localDomAccessor.findChild selector
				jqueryControl.setValueChangeListener (newValue) =>
					@model.updateAttribute attributeName, newValue

	redraw: =>
		if not @_prerendered
			@_initialRender()
			@_prerendered = true

		if @refreshRender?
			@refreshRender()

	_initialRender: ->
		@delegateEvents()
		@refreshElements()
