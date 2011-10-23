class Controller extends Spine.Controller
	setModel: (model) ->
		assert model?.bind?, 'model should exist and have method \'bind\''
		@item = model
		@item.bind "update",  @redraw
		@item.bind "destroy", @destroy

	render: ->
		@_initDOM()
		@_initChildElements()
	
	_initDOM: ->
		localRoot = @_templateAccessor.getTemplateByClass @_domClass
		@_localDomAccessor = @_newLocalDomAccessor localRoot

	_initChildElements: ->
		for selector, attributeName of @_childELementDescriptions
			do (selector, attributeName) =>
				jqueryControl = @_newJqueryControl()
				jqueryControl.setDomAccessor @_localDomAccessor.find selector
				jqueryControl.setValueChangeListener (newValue) =>
					@item.updateAttribute attributeName, newValue

	redraw: =>
		if not @_prerendered
			@_initialRender()
			@_prerendered = true

		if @refreshRender?
			@refreshRender()

	_initialRender: ->
		@delegateEvents()
		@refreshElements()
